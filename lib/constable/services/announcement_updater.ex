defmodule Constable.Services.AnnouncementUpdater do
  import Ecto.Query

  alias Constable.Announcement
  alias Constable.AnnouncementInterest
  alias Constable.Services.AnnouncementInterestAssociator
  alias Constable.Repo

  def update(announcement, params, interest_names) do
    changeset = Announcement.update_changeset(announcement, params)

    case Repo.update(changeset) do
      {:ok, announcement} ->
        announcement
        |> clear_interests
        |> update_interests(interest_names)
        {:ok, announcement}
      error -> error
    end
  end

  defp clear_interests(announcement) do
    Repo.delete_all(from ai in AnnouncementInterest,
      where: ai.announcement_id == ^announcement.id
    )

    announcement
  end

  defp update_interests(announcement, names) do
    AnnouncementInterestAssociator.add_interests(announcement, names)
  end
end
