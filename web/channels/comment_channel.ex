defmodule ConstableApi.CommentChannel do
  use ConstableApi.AuthorizedChannel
  alias ConstableApi.Repo
  alias ConstableApi.Announcement
  alias ConstableApi.Comment
  alias ConstableApi.Queries
  alias ConstableApi.Subscription
  alias ConstableApi.Serializers

  def handle_in("comments:create", %{"body" => body, "announcement_id" => announcement_id}, socket) do
    comment = %Comment{
      user_id: current_user_id(socket),
      body: body,
      announcement_id: announcement_id
    }
    |> Repo.insert
    |> Repo.preload(:user)
    |> Repo.preload(:announcement)

    update_announcement_timestamps(announcement_id)
    email_subscribers(comment)

    broadcast socket, "comments:create", Serializers.to_json(comment)
  end

  defp email_subscribers(comment) do
    announcement_id = comment.announcement_id
    users = Repo.all(Queries.Subscription.for_announcement(announcement_id))
    |> Enum.map(fn (subscription) -> subscription.user end)

    Pact.get(:comment_mailer).created(comment, users)
  end

  defp update_announcement_timestamps(announcement_id) do
    announcement = Repo.get(Announcement, announcement_id)
    Repo.update(%{announcement | updated_at: Ecto.DateTime.utc})
  end
end
