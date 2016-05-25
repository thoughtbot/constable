defmodule Constable.SessionController do
  use Constable.Web, :controller

  def new(conn, _params) do
    if conn.assigns[:current_user] do
      conn |> redirect(to: home_path(conn, :index))
    else
      conn
      |> put_layout("login.html")
      |> render("new.html")
    end
  end
end
