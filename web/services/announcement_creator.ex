defmodule Constable.Services.AnnouncementCreator do
  import Ecto.Query
  alias Constable.Repo
  alias Constable.Interest
  alias Constable.AnnouncementInterest
  alias Constable.Announcement

  def create(announcement_params, interest_names) do
    create_announcement(announcement_params)
    |> add_interests(interest_names)
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

  defp get_or_create_interests(names) do
    List.wrap(names)
    |> Enum.uniq
    |> Enum.reject(&blank_interest?/1)
    |> Enum.map(fn(name) ->
      get_interest_by_name(name) || create_interest(%{name: name})
    end)
  end

  defp blank_interest?(" " <> rest), do: blank_interest?(rest)
  defp blank_interest?(""), do: true
  defp blank_interest?(_), do: false

  defp create_interest(params) do
    Interest.changeset(%Interest{}, params) |> Repo.insert
  end

  defp get_interest_by_name(interest_name) do
    Repo.get_by(Interest, name: interest_name)
  end

  defp associate_interests_with_announcement(interests, announcement) do
    Enum.each(interests, fn(interest) ->
      %AnnouncementInterest{interest_id: interest.id}
      |> Map.merge(%{announcement_id: announcement.id})
      |> Repo.insert
    end)
  end
end
