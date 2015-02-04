defmodule ConstableApi.AnnouncementChannel do
  use Phoenix.Channel
  alias ConstableApi.Repo
  alias ConstableApi.Announcement

  def join(_topic, _auth_message, socket) do
    {:ok, socket}
  end

  def handle_in("announcements:index", _params, socket) do
    announcements = Repo.all(Announcement)
    reply socket, "announcements:index", %{announcements: announcements}
    {:ok, socket}
  end

  def handle_in("announcements:create", %{"title" => title, "body" => body}, socket) do
    announcement = %Announcement{title: title, body: body} |> Repo.insert
    broadcast socket, "announcements:create", announcement
    {:ok, socket}
  end
end
