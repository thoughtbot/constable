defmodule Constable.UserIdentifier do
  def sign_user_id(conn, user_id) do
    Phoenix.Token.sign(conn, "user_id", user_id)
  end

  def verify_signed_user_id(conn) do
    Phoenix.Token.verify(conn, "user_id", conn.cookies["user_id"])
  end
end
