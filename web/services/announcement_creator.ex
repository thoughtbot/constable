defmodule Constable.Services.AnnouncementCreator do
  import Ecto.Query

  alias Constable.Repo
  alias Constable.Announcement
  alias Constable.Subscription
  alias Constable.Emails
  alias Constable.Mailer

  alias Constable.Services.AnnouncementInterestAssociator
  alias Constable.Services.MentionFinder
  alias Constable.Services.SlackHook

  def create(params, interest_names) do
    changeset = Announcement.create_changeset(%Announcement{}, params)
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
    |> subscribe_users(interested_users)
    |> email_users(interested_users)
    |> email_mentioned_users(mentioned_users)
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
    Ecto.assoc(announcement, :interested_users)
    |> where([u1], u1.active == true)
    |> Repo.all
  end

  def find_mentioned_users(announcement) do
    MentionFinder.find_users(announcement.body)
  end

  defp subscribe_user(announcement, user_id) do
    params = %{
      user_id: user_id,
      announcement_id: announcement.id
    }

    Repo.get_by(Subscription, params) || insert_subscription(params)
  end

  defp insert_subscription(params) do
    Subscription.changeset(params) |> Repo.insert!
  end
end
