defmodule Constable.UserSocket do
  use Phoenix.Socket

  alias Constable.Repo
  alias Constable.User

  channel "update", Constable.UpdateChannel

  transport :websocket, Phoenix.Transports.WebSocket, check_origin: false
  transport :longpoll, Phoenix.Transports.LongPoll

  def connect(%{"token" => token}, socket) do
    if user = user_with_token(token) do
      socket = assign(socket, :current_user_id, user.id)
      {:ok, socket}
    else
      {:error, "Unauthorized"}
    end
  end

  def id(_socket), do: nil

  defp user_with_token(token) do
    Repo.get_by!(User, token: token)
  end
end
