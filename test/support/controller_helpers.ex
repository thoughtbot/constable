defmodule ConstableApi.ControllerHelpers do
  import ExUnit.Assertions
  import Plug.Conn

  def assert_redirected(conn, location) do
    assert conn.status in [301, 302]
    assert get_resp_header(conn, "Location") == [location]
  end
end
