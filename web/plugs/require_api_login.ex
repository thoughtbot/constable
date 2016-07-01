defmodule Constable.Plugs.RequireApiLogin do
  import Plug.Conn

  alias Constable.Repo
  alias Constable.User

  def init(default), do: default

  def call(conn, _) do
    case find_user(conn) do
      nil ->
        unauthorized(conn)
      user ->
        conn |> assign(:current_user, user)
    end
  end

  def find_user(conn) do
    fetch_token(conn)
    |> find_user_from_token
  end

  def fetch_token(conn) do
    get_req_header(conn, "authorization") |> List.first
  end

  def find_user_from_token(nil), do: nil
  def find_user_from_token(token) do
    Repo.get_by(User.active, token: token)
  end

  def unauthorized(conn) do
    conn |> send_resp(401, "") |> halt
  end
end
