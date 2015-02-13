defmodule ConstableApi.AnnouncementChannel do
  use Phoenix.Channel
  alias ConstableApi.Repo
  alias ConstableApi.Announcement
  alias ConstableApi.Serializers
  alias ConstableApi.Queries
  import ConstableApi.Channel.Helpers
  import Ecto.Query

  def join(_topic, %{"token" => token}, socket) do
    authorize_socket(socket, token)
  end

  def handle_in("announcements:index", _params, socket) do
    announcements =
      Repo.all(Queries.Announcement.with_sorted_comments)
      |> Enum.map(&Serializers.to_json/1)
      |> set_ids_as_keys
    reply socket, "announcements:index", %{announcements: announcements}
  end

  def handle_in("announcements:create", %{"title" => title, "body" => body}, socket) do
    announcement =
      %Announcement{title: title, body: body, user_id: current_user_id(socket)}
      |> Repo.insert
      |> Repo.preload([:user, comments: :user])
    Pact.get(:announcement_mailer).created(announcement)
    broadcast socket, "announcements:create", Serializers.to_json(announcement)
  end

  defp set_ids_as_keys(announcements) do
    Enum.reduce(announcements, %{}, fn(announcement, announcements) ->
      Map.put(announcements, to_string(announcement.id), announcement)
    end)
  end
end
