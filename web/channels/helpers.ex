defmodule ConstableApi.Channel.Helpers do
  alias ConstableApi.User
  alias ConstableApi.Repo
  import Ecto.Query

  def authorize_socket(socket, token) do
    if user_with_token_exists?(token) do
      {:ok, socket}
    else
      {:error, socket, :unauthorized}
    end
  end

  defp user_with_token_exists?(token) do
    Repo.one(from u in User, where: u.token == ^token)
  end
end
