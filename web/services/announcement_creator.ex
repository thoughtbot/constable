defmodule Constable.Services.AnnouncementCreator do
  import Ecto.Query
  alias Constable.Repo
  alias Constable.Interest
  alias Constable.AnnouncementInterest
  alias Constable.Announcement
  alias Constable.Subscription
  alias Constable.Api.InterestView

  def create(announcement_params, interest_names) do
    case create_announcement(announcement_params) do
      {:ok, announcement} ->
        announcement = announcement
        |> add_interests(interest_names)
        |> subscribe_author

        {:ok, announcement}
      error -> error
    end
  end

  defp create_announcement(params) do
    Announcement.changeset(%Announcement{}, :create, params)
    |> Repo.insert
  end

  defp add_interests(announcement, interest_names) do
    interest_names
    |> get_or_create_interests
    |> associate_interests_with_announcement(announcement)
    announcement
  end

  defp subscribe_author(announcement) do
    Subscription.changeset(:create, %{
      user_id: announcement.user_id,
      announcement_id: announcement.id
    })
    |> Repo.insert!
    announcement
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
