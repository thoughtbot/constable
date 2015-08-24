defmodule Constable.Api.CommentView do
  use Constable.Web, :view

  def render("index.json", %{comments: comments}) do
    %{data: render_many(comments, Constable.Api.CommentView, "comment.json")}
  end

  def render("show.json", %{comment: comment}) do
    %{data: render_one(comment, Constable.Api.CommentView, "comment.json")}
  end

  def render("comment.json", %{comment: comment}) do
    %{
      id: comment.id,
      body: comment.body,
      announcement_id: comment.announcement_id,
      user_id: comment.user_id,
    }
  end
end
