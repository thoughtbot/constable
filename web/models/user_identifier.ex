defmodule Constable.UserIdentifier do
  @one_week 86400 * 7
  @salt "user_id"

  def sign_user_id(conn, user_id) do
    Phoenix.Token.sign(conn, @salt, user_id)
  end

  def verify_signed_user_id(conn) do
    Phoenix.Token.verify(conn, @salt, conn.cookies["user_id"], max_age: @one_week)
  end
end
