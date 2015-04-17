defmodule Constable.AnnouncementChannel do
  use Constable.AuthorizedChannel
  alias Constable.Repo
  alias Constable.Announcement
  alias Constable.Serializers
  alias Constable.Queries
  alias Constable.Services.AnnouncementCreator

  def handle_in("all", _params, socket) do
    announcements =
      Repo.all(Queries.Announcement.with_sorted_comments)

    {:reply, {:ok, %{announcements: announcements}}, socket}
  end

  def handle_in("show", %{"id" => id}, socket) do
    announcement = Repo.get(Announcement, id) |> preload_associations

    {:reply, {:ok, %{announcement: announcement}}, socket}
  end

  def handle_in("create", %{"announcement" => announcement_params}, socket) do
    announcement =
      announcement_params
      |> Map.merge(%{"user_id" => current_user_id(socket)})
      |> AnnouncementCreator.create(announcement_params["interests"])
      |> preload_associations

    Pact.get(:announcement_mailer).created(announcement)

    broadcast! socket, "add", announcement

    {:reply, {:ok, %{announcement: announcement}}, socket}
  end

  def handle_in("update", attributes = %{"announcement" => announcement}, socket) do
    id = Map.get(announcement, "id")
    user_id = current_user_id(socket)
    announcement = Repo.one(
      Queries.Announcement.find_by_id_and_user(id, user_id)
    )

    if announcement do
      announcement = announcement
        |> update_announcement(attributes)
        |> preload_associations
        |> broadcast_announcement(socket, "announcements:update")
    end
    {:noreply, socket}
  end

  defp broadcast_announcement(announcement, socket, topic) do
    broadcast!(socket, "update", %{announcement: announcement})
  end

  defp update_announcement(announcement, attributes) do
    Announcement.changeset(announcement, :update, attributes)
    |> Repo.update
  end

  defp preload_associations(announcement) do
    Repo.preload(announcement, [:interests, :user, comments: :user])
  end
end
