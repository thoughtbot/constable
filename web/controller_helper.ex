defmodule Constable.ControllerHelper do
  def unauthorized(conn) do
    Plug.Conn.send_resp(conn, 401, "")
  end

  def current_user(conn) do
    conn.assigns[:current_user]
  end
end
