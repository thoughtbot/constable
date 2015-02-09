defmodule ConstableApi.AnnouncementChannel do
  use Phoenix.Channel
  alias ConstableApi.Repo
  alias ConstableApi.Announcement
  alias ConstableApi.User
  alias ConstableApi.Serializers
  import Ecto.Query

  def join(_topic, %{"token" => token}, socket) do
    if get_user_with_token(token) do
      {:ok, socket}
    else
      {:error, socket, :unauthorized}
    end
  end

  def handle_in("announcements:index", _params, socket) do
    announcements = Repo.all(from a in Announcement, preload: :comments)
    |> Enum.map(&Serializers.to_json/1)
    |> set_ids_as_keys
    reply socket, "announcements:index", %{announcements: announcements}
    {:ok, socket}
  end

  def handle_in("announcements:create", %{"title" => title, "body" => body}, socket) do
    announcement = %Announcement{title: title, body: body} |> Repo.insert
    broadcast socket, "announcements:create", announcement
    {:ok, socket}
  end

  defp set_ids_as_keys(announcements) do
    Enum.reduce(announcements, %{}, fn(announcement, announcements) ->
      Map.put(announcements, to_string(announcement.id), announcement)
    end)
  end

  defp get_user_with_token(token) do
    Repo.one(from u in User, where: u.token == ^token)
  end
end
