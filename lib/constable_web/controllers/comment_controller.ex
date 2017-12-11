defmodule ConstableWeb.CommentController do
  use Constable.Web, :controller

  alias Constable.Announcement
  alias Constable.Comment
  alias Constable.Services.CommentCreator

  def create(conn, %{"announcement_id" => announcement_id, "comment" => comment_params}) do
    comment_params = comment_params
      |> Map.put("user_id", conn.assigns.current_user.id)
      |> Map.put("announcement_id", announcement_id)

    case CommentCreator.create(comment_params) do
      {:ok, _comment} ->
        redirect(conn, to: announcement_path(conn, :show, announcement_id))
      {:error, _changeset} ->
        conn
        |> put_flash(:error, gettext("Comment was invalid"))
        |> redirect(to: announcement_path(conn, :show, announcement_id))
    end
  end

  def edit(conn, %{"announcement_id" => announcement_id, "id" => comment_id}) do
    announcement = Repo.get!(Announcement, announcement_id)
    comment = Repo.get!(Comment, comment_id)
    users = Repo.all(Constable.User)
    changeset = Comment.update_changeset(comment, %{})

    conn
    |> render("edit.html",
      announcement: announcement,
      changeset: changeset,
      comment: comment,
      users: users
    )
  end

  def update(conn, %{"announcement_id" => announcement_id, "id" => id, "comment" => comment_params}) do
    current_user = conn.assigns.current_user
    announcement = Repo.get!(Announcement, announcement_id)
    comment = Ecto.assoc(current_user, :comments) |> Repo.get!(id)
    changeset = Comment.update_changeset(comment, comment_params)

    case Repo.update(changeset) do
      {:ok, comment} ->
        redirect_to_comment_on_announcement_page(conn, comment)
      {:error, _changeset} ->
        conn
        |> render("edit.html",
          announcement: announcement,
          changeset: changeset,
          comment: comment
        )
    end
  end

  defp redirect_to_comment_on_announcement_page(conn, comment) do
    redirect(conn, to: announcement_path(conn, :show, comment.announcement_id) <> "#comment-#{comment.id}")
  end
end
