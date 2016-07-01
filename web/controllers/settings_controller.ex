defmodule Constable.SettingsController do
  use Constable.Web, :controller

  alias Constable.User

  def show(conn, _params) do
    changeset = User.settings_changeset(conn.assigns.current_user)
    render conn, "show.html", changeset: changeset
  end

  def update(conn, %{"user" => user_params}) do
    changeset = User.settings_changeset(conn.assigns.current_user, user_params)

    case Repo.update(changeset) do
      {:ok, _user} ->
        render conn, "show.html", changeset: changeset
      {:error, changeset} ->
        conn
        |> put_flash(:error, gettext("Something went wrong!"))
        |> render("show.html", changeset: changeset)
    end
  end
end
