defmodule Constable.Plugs.RequireLogin do
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
    |> put_resp_header("location", "/")
    |> send_resp(302, "")
    |> halt
  end
end
