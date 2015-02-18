defmodule ConstableApi.CommentChannel do
  use Phoenix.Channel
  alias ConstableApi.Repo
  alias ConstableApi.Announcement
  alias ConstableApi.Comment
  alias ConstableApi.Serializers
  import ConstableApi.Channel.Helpers

  def join(_topic, %{"token" => token}, socket) do
    authorize_socket(socket, token)
  end

  def handle_in("comments:create", %{"body" => body, "announcement_id" => announcement_id}, socket) do
    comment = %Comment{
      user_id: current_user_id(socket),
      body: body,
      announcement_id: announcement_id
    }
    |> Repo.insert
    |> Repo.preload(:user)
    |> Repo.preload(:announcement)

    broadcast socket, "comments:create", Serializers.to_json(comment)

    update_announcement_timestamps(announcement_id)
    Pact.get(:comment_mailer).created(comment)
  end

  defp update_announcement_timestamps(announcement_id) do
    announcement = Repo.get(Announcement, announcement_id)
    Repo.update(%{announcement | updated_at: Ecto.DateTime.utc})
  end
end
