defmodule ConstableWeb.Api.CommentController do
  use Constable.Web, :controller

  alias Constable.Services.CommentCreator

  def create(conn, %{"comment" => params}) do
    current_user = current_user(conn)
    params = Map.put(params, "user_id", current_user.id)

    case CommentCreator.create(params) do
      {:ok, comment} ->
        conn |> put_status(201) |> render("show.json", comment: comment)
      {:error, changeset} ->
        conn
        |> put_status(422)
        |> render(ConstableWeb.ChangesetView, "error.json", changeset: changeset)
    end
  end
end
