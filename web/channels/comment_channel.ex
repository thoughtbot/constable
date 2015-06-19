defmodule Constable.CommentChannel do
  use Constable.AuthorizedChannel
  alias Constable.Repo
  alias Constable.Announcement
  alias Constable.Comment
  alias Constable.Queries
  alias Constable.Subscription

  def handle_in("create", %{"comment" => comment_params}, socket) do
    comment = insert_comment(socket, comment_params)
    update_announcement_timestamps(comment.announcement_id)
    email_subscribers(comment)

    broadcast socket, "add", %{comment: comment}
    {:reply, {:ok, %{comment: comment}}, socket}
  end

  defp insert_comment(socket, comment_params) do
    %{"body" => body, "announcement_id" => announcement_id} = comment_params

    %Comment{
      user_id: current_user_id(socket),
      body: body,
      announcement_id: announcement_id
    }
    |> Repo.insert!
    |> Repo.preload([:user, :announcement])
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
