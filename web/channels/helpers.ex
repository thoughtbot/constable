defmodule ConstableApi.Channel.Helpers do
  alias ConstableApi.User
  alias ConstableApi.Repo
  alias Phoenix.Socket
  import Ecto.Query

  def authorize_socket(socket, token) do
    if user = user_with_token(token) do
      socket = Socket.assign(socket, :current_user_id, user.id)
      {:ok, socket}
    else
      {:error, :unauthorized, socket}
    end
  end

  def current_user_id(socket) do
    socket.assigns[:current_user_id]
  end

  defp user_with_token(token) do
    Repo.one(from u in User, where: u.token == ^token)
  end
end
