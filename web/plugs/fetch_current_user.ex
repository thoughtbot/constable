defmodule Constable.Plugs.FetchCurrentUser do
  import Plug.Conn

  alias Constable.{Repo, User}

  def init(opts), do: opts

  def call(conn, _) do
    case find_user(conn) do
      nil -> conn
      user ->
        conn |> assign(:current_user, user)
    end
  end

  def find_user(conn) do
    user_id = get_session(conn, :user_id)

    if user_id do
      Repo.get(User, user_id)
    end
  end
end
