defmodule ConstableWeb.UserSocket do
  use Phoenix.Socket
  require Logger

  alias Constable.Repo
  alias Constable.User

  def connect(%{"token" => token}, socket, _connect_info) do
    if user = user_with_token(token) do
      socket = assign(socket, :current_user, user)
      {:ok, socket}
    else
      {:error, "Unauthorized"}
    end
  end

  def connect(params, _socket, _connect_info) do
    Logger.debug("Expected socket params to have a 'token', got: #{inspect(params)}")
  end

  def id(_socket), do: nil

  defp user_with_token(token) do
    Repo.get_by!(User, token: token)
  end
end
