defmodule ConstableWeb.Api.ReactionController do
  use ConstableWeb, :controller

  alias Constable.Services.ReactionCreator
  alias Constable.Announcement
  alias Constable.Comment

  def create(conn, %{"reactable" => reactable_params, "reaction" => reaction_params}) do
    current_user = current_user(conn)

    if current_user do
      reaction_params = Map.put(reaction_params, "user_id", current_user.id)

      case ReactionCreator.create(reactable_params, reaction_params) do
        {:ok, reaction} ->
          conn |> put_status(201) |> render("show.json", reaction: reaction)

        {:error, changeset} ->
          conn
          |> put_status(422)
          |> render(ConstableWeb.ChangesetView, "error.json", changeset: changeset)
      end
    else
      unauthorized(conn)
    end
  end

  def delete(conn, %{"id" => id, "reactable" => reactable_params}) do
    current_user = current_user(conn)

    reactable = reactable_from_params(reactable_params)

    reaction = Repo.get(Ecto.assoc(reactable, :reactions), id)

    if reaction && current_user.id == reaction.user_id do
      Repo.delete!(reaction)
      send_resp(conn, 204, "")
    else
      unauthorized(conn)
    end
  end

  defp reactable_from_params(params) do
    case params["type"] do
      "announcement" -> Repo.get!(Announcement, params["id"])
      "comment" -> Repo.get!(Comment, params["id"])
    end
  end
end
