defmodule Constable.Services.AnnouncementCreator do
  import Ecto.Query
  alias Constable.Repo
  alias Constable.Interest
  alias Constable.AnnouncementInterest
  alias Constable.Announcement
  alias Constable.Subscription
  alias Constable.Api.InterestView

  def create(params, interest_names) do
    changeset = Announcement.changeset(%Announcement{}, :create, params)
    case Repo.insert(changeset) do
      {:ok, announcement} ->
        announcement
        |> add_interests(interest_names)
        |> subscribe_author
        |> email_and_subscribe_users

        {:ok, announcement}
      error -> error
    end
  end

  defp add_interests(announcement, interest_names) do
    interest_names
    |> get_or_create_interests
    |> associate_interests_with_announcement(announcement)
  end

  defp subscribe_author(announcement) do
    subscribe_user(announcement, announcement.user_id)
    announcement
  end

  defp email_and_subscribe_users(announcement) do
    interested_users = find_interested_users(announcement)
    announcement
    |> email_users(interested_users)
    |> subscribe_users(interested_users)
  end

  defp email_users(announcement, users) do
    Pact.get(:announcement_mailer).created(announcement, users)
    announcement
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

  defp subscribe_user(announcement, user_id) do
    Subscription.changeset(:create, %{
      user_id: user_id,
      announcement_id: announcement.id
    })
    |> Repo.insert!
  end

  defp get_or_create_interests(names) do
    List.wrap(names)
    |> Enum.reject(&blank_interest?/1)
    |> Enum.map(fn(name) ->
      interest = Interest.changeset(%{name: name})

      case Repo.get_by(Interest, interest.changes) do
        nil -> create_and_broadcast(interest)
        interest -> interest
      end
    end)
    |> Enum.uniq
  end

  defp blank_interest?(" " <> rest), do: blank_interest?(rest)
  defp blank_interest?(""), do: true
  defp blank_interest?(_), do: false

  defp associate_interests_with_announcement(interests, announcement) do
    Enum.each(interests, fn(interest) ->
      %AnnouncementInterest{interest_id: interest.id}
      |> Map.merge(%{announcement_id: announcement.id})
      |> Repo.insert!
    end)

    announcement
  end

  defp create_and_broadcast(changeset) do
    interest = changeset |> Repo.insert!

    Constable.Endpoint.broadcast!(
      "update",
      "interest:add", 
      InterestView.render("show.json", %{interest: interest})
    )

    interest
  end
end
