defmodule Constable.Services.CommentCreator do
  alias Constable.Api.CommentView
  alias Constable.Comment
  alias Constable.Queries
  alias Constable.Repo
  alias Constable.Services.MentionFinder

  def create(params) do
    changeset = Comment.changeset(:create, params)

    case Repo.insert(changeset) do
      {:ok, comment} ->
        mentioned_users = email_mentioned_users(comment)
        email_subscribers(comment, mentioned_users)
        broadcast(comment)
        {:ok, comment}
      {:error, changeset} -> {:error, changeset}
    end
  end

  defp email_subscribers(comment, mentioned_users) do
    users = find_subscribed_users(comment.announcement_id) -- mentioned_users
    |> Enum.reject(fn (user) -> user.id == comment.user_id end)

    Pact.get(:comment_mailer).created(comment, users)
    comment
  end

  defp email_mentioned_users(comment) do
    users = MentionFinder.find_users(comment.body)
    Pact.get(:comment_mailer).mentioned(comment, users)
    users
  end

  defp find_subscribed_users(announcement_id) do
    Repo.all(Queries.Subscription.for_announcement(announcement_id))
    |> Enum.map(fn (subscription) -> subscription.user end)
  end

  defp broadcast(comment) do
    Constable.Endpoint.broadcast!(
      "update",
      "comment:add", 
      CommentView.render("show.json", %{comment: comment})
    )
  end
end
