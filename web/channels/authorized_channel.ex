defmodule ConstableApi.AuthorizedChannel do
  defmacro __using__(_options) do
    quote do
      use Phoenix.Channel
      import Ecto.Query

      def join(_topic, %{"token" => token}, socket) do
        authorize_socket(socket, token)
      end

      def authorize_socket(socket, token) do
        if user = user_with_token(token) do
          socket = Phoenix.Socket.assign(socket, :current_user_id, user.id)
          {:ok, socket}
        else
          {:error, :unauthorized, socket}
        end
      end

      def current_user_id(socket) do
        socket.assigns[:current_user_id]
      end

      defp user_with_token(token) do
        ConstableApi.Repo.one(from u in ConstableApi.User,
          where: u.token == ^token
        )
      end
    end
  end
end
