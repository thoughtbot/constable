defmodule ConstableWeb.HomeController do
  use ConstableWeb, :controller

  def index(conn, _params) do
    conn |> redirect_to_original_path_or_announcement_index
  end

  defp redirect_to_original_path_or_announcement_index(conn) do
    original_request_path = get_session(conn, :original_request_path)

    if original_request_path do
      conn
      |> delete_session(:original_request_path)
      |> redirect(to: original_request_path)
    else
      conn |> redirect(to: Routes.announcement_path(conn, :index))
    end
  end
end
