defmodule Constable.Plugs.RequireWebLogin do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _) do
    if conn.assigns[:current_user] do
      conn
    else
      conn |> redirect_to_login
    end
  end

  defp redirect_to_login(conn) do
    conn
    |> maybe_store_request_path
    |> Phoenix.Controller.redirect(to: "/session/new")
    |> halt
  end

  defp maybe_store_request_path(conn) do
    if conn.method == "GET" do
      conn |> put_session(:original_request_path, conn.request_path)
    else
      conn
    end
  end
end
