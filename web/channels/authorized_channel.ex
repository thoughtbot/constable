defmodule Constable.AuthorizedChannel do
  defmacro __using__(_options) do
    quote do
      use Phoenix.Channel
      import Ecto.Query

      def join(_topic, %{"token" => token}, socket) do
        authorize_socket(socket, token)
      end

      def authorize_socket(socket, token) do
        if user = user_with_token(token) do
          socket = put_in(socket.assigns[:current_user_id], user.id)
          # Not sure why this isn't working?
          # socket = Phoenix.Socket.assign(socket, :current_user_id, user.id)
          {:ok, socket}
        else
          {:error, :unauthorized}
        end
      end

      def current_user_id(socket) do
        socket.assigns[:current_user_id]
      end

      def reply(socket, view, template, payload) do
        rendered_payload = view.render(template, payload)
        {:reply, {:ok, payload}, socket}
      end

      defp user_with_token(token) do
        Constable.Repo.one(from u in Constable.User,
          where: u.token == ^token
        )
      end
    end
  end
end
