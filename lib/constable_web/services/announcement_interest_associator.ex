defmodule Constable.Services.AnnouncementInterestAssociator do
  alias Constable.Repo
  alias Constable.Interest
  alias Constable.AnnouncementInterest

  alias ConstableWeb.Api.InterestView

  def add_interests(announcement, names) do
    get_or_create_interests(names)
    |> associate_interests_with_announcement(announcement)
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

  defp associate_interests_with_announcement(interests, announcement) do
    Enum.each(interests, fn(interest) ->
      %AnnouncementInterest{
        interest_id: interest.id,
        announcement_id: announcement.id
      }
      |> Repo.insert!
    end)

    announcement
  end

  defp blank_interest?(" " <> rest), do: blank_interest?(rest)
  defp blank_interest?(""), do: true
  defp blank_interest?(_), do: false

  defp create_and_broadcast(changeset) do
    interest = changeset |> Repo.insert!

    ConstableWeb.Endpoint.broadcast!(
      "update",
      "interest:add",
      InterestView.render("show.json", %{interest: interest})
    )

    interest
  end
end
