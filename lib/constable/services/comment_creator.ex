defmodule Constable.Services.CommentCreator do
  alias Constable.Comment
  alias Constable.Repo
  alias Constable.Services.MentionFinder
  alias Constable.Subscription
  alias Constable.Emails
  alias Constable.Mailer

  def create(params) do
    changeset = Comment.create_changeset(params)

    case Repo.insert(changeset) do
      {:ok, comment} ->
        comment = comment |> Repo.preload([:user, announcement: :user])
        broadcast(comment)
        mentioned_users = email_mentioned_users(comment)
        email_subscribers(comment, mentioned_users)
        subscribe_comment_author(comment)
        {:ok, comment}

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  defp subscribe_comment_author(comment) do
    comment
    |> Map.take([:announcement_id, :user_id])
    |> Subscription.changeset()
    |> Repo.insert!(on_conflict: :nothing)
  end

  defp email_subscribers(comment, mentioned_users) do
    users =
      (find_subscribed_users(comment.announcement_id) -- mentioned_users)
      |> Enum.reject(fn user -> user.id == comment.user_id end)

    Emails.new_comment(comment, users) |> Mailer.deliver_later!()
  end

  defp email_mentioned_users(comment) do
    users = MentionFinder.find_users(comment.body)

    Emails.new_comment_mention(comment, users) |> Mailer.deliver_later!()
    users
  end

  defp find_subscribed_users(announcement_id) do
    Repo.all(Subscription.for_announcement(announcement_id))
    |> Enum.map(fn subscription -> subscription.user end)
  end

  defp broadcast(comment) do
    Constable.PubSub.broadcast_new_comment(comment)
  end
end
