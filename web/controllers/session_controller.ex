defmodule Constable.SessionController do
  use Constable.Web, :controller

  def new(conn, _params) do
    if conn.assigns[:current_user] do
      conn |> redirect_to_original_path_or_announcement_index
    else
      conn
      |> put_layout("login.html")
      |> render("new.html")
    end
  end

  defp redirect_to_original_path_or_announcement_index(conn) do
    original_request_path = get_session(conn, :original_request_path)

    if original_request_path do
      conn
      |> delete_session(:original_request_path)
      |> redirect(to: original_request_path)
    else
      conn |> redirect(to: announcement_path(conn, :index))
    end
  end
end
