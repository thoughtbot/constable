defmodule Constable.Plugs.SetUserIdFromParams do
  alias Constable.UserIdentifier

  def init(opts), do: opts

  def call(conn, _opts) do
    if user_id = conn.params["as"] do
      set_user_id_cookie(conn, user_id)
    else
      conn
    end
  end

  defp set_user_id_cookie(conn, user_id) do
    signed_user_id = UserIdentifier.sign_user_id(conn, user_id)
    conn |> Plug.Conn.put_resp_cookie("user_id", signed_user_id)
  end
end
