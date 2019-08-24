defmodule ConstableWeb.Api.CommentView do
  use ConstableWeb, :view

  alias ConstableWeb.Api.ReactionView

  def render("index.json", %{comments: comments}) do
    comments = comments |> Repo.preload(:reactions)

    %{comments: render_many(comments, ConstableWeb.Api.CommentView, "comment.json")}
  end

  def render("show.json", %{comment: comment}) do
    comment = comment |> Repo.preload(:reactions)

    %{comment: render_one(comment, ConstableWeb.Api.CommentView, "comment.json")}
  end

  def render("comment.json", %{comment: comment}) do
    %{
      id: comment.id,
      body: comment.body,
      announcement_id: comment.announcement_id,
      user_id: comment.user_id,
      inserted_at: comment.inserted_at,
      reactions: render_many(comment.reactions, ReactionView, "reaction.json")
    }
  end
end
