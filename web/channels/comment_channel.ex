defmodule ConstableApi.CommentChannel do
  use Phoenix.Channel
  alias ConstableApi.Repo
  alias ConstableApi.Announcement
  alias ConstableApi.Comment
  alias ConstableApi.Serializers
  alias ConstableApi.Channel.Helpers

  def join(_topic, %{"token" => token}, socket) do
    Helpers.authorize_socket(socket, token)
  end

  def handle_in("comments:create", %{"body" => body, "announcement_id" => announcement_id}, socket) do
    comment = %Comment{body: body, announcement_id: announcement_id}
    |> Repo.insert

    reply socket, "comments:create", Serializers.to_json(comment)
    broadcast socket, "comments:create", Serializers.to_json(comment)
  end
end
