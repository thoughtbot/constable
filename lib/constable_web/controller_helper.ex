defmodule ConstableWeb.ControllerHelper do
  alias Constable.Plugs.RequireApiLogin

  def unauthorized(conn) do
    Plug.Conn.send_resp(conn, 401, "")
  end

  def current_user(conn) do
    RequireApiLogin.find_user(conn)
  end

  def page_title(conn, title) do
    Plug.Conn.assign(conn, :page_title, title)
  end
end
