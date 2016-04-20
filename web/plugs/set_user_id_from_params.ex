defmodule Constable.Plugs.SetUserIdFromParams do
  def init(opts), do: opts

  def call(conn, _opts) do
    if user_id = conn.params["as"] do
      Plug.Conn.put_session(conn, :user_id, user_id)
    else
      conn
    end
  end
end
