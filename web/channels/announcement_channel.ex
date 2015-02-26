defmodule Constable.AnnouncementChannel do
  use Constable.AuthorizedChannel
  alias Constable.Repo
  alias Constable.Announcement
  alias Constable.Serializers
  alias Constable.Queries
  alias Constable.Services.AnnouncementCreator

  def handle_in("announcements:index", _params, socket) do
    announcements =
      Repo.all(Queries.Announcement.with_sorted_comments)
      |> Enum.map(&Serializers.to_json/1)
      |> Serializers.ids_as_keys
    reply socket, "announcements:index", %{announcements: announcements}
  end

  def handle_in("announcements:create", announcement_params, socket) do
    announcement =
      announcement_params
      |> Map.merge(%{"user_id" => current_user_id(socket)})
      |> AnnouncementCreator.create(announcement_params["interests"])
      |> preload_associations
    Pact.get(:announcement_mailer).created(announcement)
    broadcast socket, "announcements:create", Serializers.to_json(announcement)
  end

  def handle_in("announcements:update", attributes = %{"id" => id}, socket) do
    user_id = current_user_id(socket)
    announcement = Repo.one(
      Queries.Announcement.find_by_id_and_user(id, user_id)
    )

    if announcement do
      announcement
        |> update_announcement(attributes)
        |> preload_associations
        |> broadcast_announcement(socket, "announcements:update")
    else
      {:ok, socket}
    end
  end

  defp broadcast_announcement(announcement, socket, topic) do
    broadcast(socket, "announcements:update", Serializers.to_json(announcement))
  end

  defp update_announcement(announcement, attributes) do
    Announcement.changeset(announcement, :update, attributes)
    |> Repo.update
  end

  defp preload_associations(announcement) do
    Repo.preload(announcement, [:interests, :user, comments: :user])
  end
end
