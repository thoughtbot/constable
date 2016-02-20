defmodule Constable.Services.AnnouncementCreator do
  alias Constable.Repo
  alias Constable.Announcement
  alias Constable.Subscription
  alias Constable.Emails
  alias Constable.Mailer

  alias Constable.Services.AnnouncementInterestAssociator
  alias Constable.Services.MentionFinder
  alias Constable.Services.SlackHook

  def create(params, interest_names) do
    changeset = Announcement.changeset(%Announcement{}, :create, params)
    case Repo.insert(changeset) do
      {:ok, announcement} ->
        announcement
        |> add_interests(interest_names)
        |> Repo.preload(:user)
        |> subscribe_author
        |> email_and_subscribe_users
        |> SlackHook.new_announcement

        {:ok, announcement}
      error -> error
    end
  end

  defp add_interests(announcement, interest_names) do
    AnnouncementInterestAssociator.add_interests(announcement, interest_names)
  end

  defp subscribe_author(announcement) do
    subscribe_user(announcement, announcement.user_id)
    announcement
  end

  defp email_and_subscribe_users(announcement) do
    mentioned_users = find_mentioned_users(announcement)
    interested_users = find_interested_users(announcement) -- mentioned_users

    announcement
    |> email_users(interested_users)
    |> email_mentioned_users(mentioned_users)
    |> subscribe_users(interested_users)
  end

  defp email_users(announcement, users) do
    users = filter_author(announcement.user_id, users)

    Emails.new_announcement(announcement, users) |> Mailer.deliver_later
    announcement
  end

  def email_mentioned_users(announcement, users) do
    users = filter_author(announcement.user_id, users)

    Emails.new_announcement_mention(announcement, users) |> Mailer.deliver_later
    announcement
  end

  defp filter_author(author_id, users)  do
    Enum.reject(users, fn(user) ->
      user.id == author_id
    end)
  end

  defp subscribe_users(announcement, interested_users) do
    interested_users
    |> Enum.filter(&Map.get(&1, :auto_subscribe))
    |> Enum.each(fn(user) ->
      subscribe_user(announcement, user.id)
    end)

    announcement
  end

  defp find_interested_users(announcement) do
    announcement
    |> Repo.preload([:interested_users])
    |> Map.get(:interested_users)
  end

  def find_mentioned_users(announcement) do
    MentionFinder.find_users(announcement.body)
  end

  defp subscribe_user(announcement, user_id) do
    Subscription.changeset(:create, %{
      user_id: user_id,
      announcement_id: announcement.id
    })
    |> Repo.get_or_insert
  end
end
