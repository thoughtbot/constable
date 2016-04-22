defmodule Constable.CommentController do
  use Constable.Web, :controller

  alias Constable.Services.CommentCreator

  plug :scrub_params, "comment"

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
end
