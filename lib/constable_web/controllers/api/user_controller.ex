defmodule ConstableWeb.Api.UserController do
  use ConstableWeb, :controller

  alias Constable.User

  def create(conn, %{"user" => user_params}) do
    changeset = User.create_changeset(%User{}, user_params)

    case Repo.insert(changeset) do
      {:ok, user} ->
        render(conn, "show.json", user: user)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(ConstableWeb.ChangesetView)
        |> render("error.json", changeset: changeset)
    end
  end

  def index(conn, _params) do
    users = all_users_ordered_by_name()

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
    changeset = User.settings_changeset(current_user, params)

    case Repo.update(changeset) do
      {:ok, user} ->
        render(conn, "show.json", user: user)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(ConstableWeb.ChangesetView, "error.json", changeset: changeset)
    end
  end

  defp all_users_ordered_by_name do
    Repo.all(User.ordered_by_name())
  end
end
