defmodule ConstableWeb.Api.CommentView do
  use Constable.Web, :view

  def render("index.json", %{comments: comments}) do
    %{comments: render_many(comments, ConstableWeb.Api.CommentView, "comment.json")}
  end

  def render("show.json", %{comment: comment}) do
    %{comment: render_one(comment, ConstableWeb.Api.CommentView, "comment.json")}
  end

  def render("comment.json", %{comment: comment}) do
    %{
      id: comment.id,
      body: comment.body,
      announcement_id: comment.announcement_id,
      user_id: comment.user_id,
      inserted_at: comment.inserted_at,
    }
  end
end
