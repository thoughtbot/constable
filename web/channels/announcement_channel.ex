defmodule ConstableApi.AnnouncementChannel do
  use Phoenix.Channel
  alias ConstableApi.Repo
  alias ConstableApi.Announcement
  alias ConstableApi.Serializers
  alias ConstableApi.Channel.Helpers
  import Ecto.Query

  def join(_topic, %{"token" => token}, socket) do
    Helpers.authorize_socket(socket, token)
  end

  def handle_in("announcements:index", _params, socket) do
    announcements = Repo.all(from a in Announcement, preload: :comments)
    |> Enum.map(&Serializers.to_json/1)
    |> set_ids_as_keys
    reply socket, "announcements:index", %{announcements: announcements}
  end

  def handle_in("announcements:create", %{"title" => title, "body" => body}, socket) do
    announcement = %Announcement{title: title, body: body} |> Repo.insert
    broadcast socket, "announcements:create", announcement
  end

  defp set_ids_as_keys(announcements) do
    Enum.reduce(announcements, %{}, fn(announcement, announcements) ->
      Map.put(announcements, to_string(announcement.id), announcement)
    end)
  end
end
