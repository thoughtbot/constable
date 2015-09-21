defmodule Constable.Api.CommentController do
  use Constable.Web, :controller

  alias Constable.Api.CommentView
  alias Constable.Services.CommentCreator

  plug :scrub_params, "comment" when action in [:create]

  def create(conn, %{"comment" => params}) do
    current_user = current_user(conn)
    params = Map.put(params, "user_id", current_user.id)

    case CommentCreator.create(params) do
      {:ok, comment} ->
        Constable.Endpoint.broadcast!(
          "update",
          "comment:add", 
          CommentView.render("show.json", %{comment: comment})
        )
        conn |> put_status(201) |> render("show.json", comment: comment)
      {:error, changeset} ->
        conn
        |> put_status(422)
        |> render(Constable.ChangesetView, "error.json", changeset: changeset)
    end
  end
end
