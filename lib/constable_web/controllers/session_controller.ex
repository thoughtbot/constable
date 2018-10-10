defmodule ConstableWeb.SessionController do
  use ConstableWeb, :controller

  def new(conn, _params) do
    if conn.assigns[:current_user] do
      conn |> redirect(to: Routes.home_path(conn, :index))
    else
      conn
      |> put_layout("login.html")
      |> render("new.html")
    end
  end

  def delete(conn, _params) do
    conn
    |> logout_user
    |> redirect(to: Routes.home_path(conn, :index))
  end

  defp logout_user(conn) do
    delete_resp_cookie(conn, "user_id")
  end
end
