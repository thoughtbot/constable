defmodule Constable.Api.UserController do
  use Constable.Web, :controller

  alias Constable.User

  def index(conn, _params) do
    users = Repo.all(User)

    render(conn, "index.json", users: users)
  end

  def show(conn, %{"id" => "me"}) do
    current_user = current_user(conn)
    render(conn, "show.json", user: current_user)
  end
  def show(conn, %{"id" => id}) do
    user = Repo.get!(User, id)
    render(conn, "show.json", user: user)
  end

  def update(conn, %{"user" => params}) do
    current_user = current_user(conn)
    changeset = User.changeset(current_user, params)

    case Repo.update(changeset) do
      {:ok, user} ->
        render(conn, "show.json", user: user)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Constable.ChangesetView, "error.json", changeset: changeset)
    end
  end
end
