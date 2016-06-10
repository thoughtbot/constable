defmodule Constable.Plugs.FetchCurrentUser do
  import Plug.Conn

  alias Constable.{Repo, User, UserIdentifier}

  def init(opts), do: opts

  def call(conn, _) do
    case find_user(conn) do
      :not_signed_in -> conn
      user ->
        conn |> assign(:current_user, user)
    end
  end

  def find_user(conn) do
    case UserIdentifier.verify_signed_user_id(conn) do
      {:ok, user_id} -> Repo.get(User.active, user_id)
      {:error, _} -> :not_signed_in
    end
  end
end
