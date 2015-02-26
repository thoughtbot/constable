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
    names
    |> Enum.uniq
    |> Enum.map(fn(name) ->
      get_interest_by_name(name) || create_interest(%{name: name})
    end)
  end

  defp create_interest(params) do
    Interest.changeset(%Interest{}, params) |> Repo.insert
  end

  defp get_interest_by_name(interest_name) do
    from(i in Interest, where: i.name == ^interest_name) |> Repo.one
  end

  defp associate_interests_with_announcement(interests, announcement) do
    Enum.each(interests, fn(interest) ->
      %AnnouncementInterest{interest_id: interest.id}
      |> Map.merge(%{announcement_id: announcement.id})
      |> Repo.insert
    end)
  end
end
