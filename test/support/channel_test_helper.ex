defmodule ChannelTestHelper do
  import ExUnit.Assertions
  alias Phoenix.Socket

  def handle_join(channel, params, socket) do
    channel.join("", params, socket)
  end

  def handle_in(socket, channel, params \\ %{}) do
    channel.handle_in(socket.topic, params, socket)
  end

  def assert_socket_broadcasted_with_payload(topic, payload) do
    assert_receive {
      :socket_broadcast,
      %Socket.Message{event: ^topic, payload: ^payload, topic: ^topic}
    }
  end

  def assert_socket_replied_with_payload(topic, payload) do
    assert_receive {
      :socket_reply,
      %Socket.Message{event: ^topic, payload: ^payload, topic: ^topic}
    }
  end

  def authenticated_socket(user, topic) when is_binary(topic) do
    authenticated_socket(user, topic: topic)
  end
  def authenticated_socket(user, attributes) do
    build_socket(attributes) |> assign_current_user(user.id)
  end

  def build_socket(topic) when is_binary(topic) do
    build_socket(topic: topic)
  end
  def build_socket(attributes) do
    Forge.socket(attributes) |> subscribe
  end

  defp subscribe(socket) do
    Phoenix.PubSub.subscribe(Constable.PubSub, self, socket.topic)
    socket
  end

  defp assign_current_user(socket, user_id) do
    Socket.assign(socket, :current_user_id, user_id)
  end
end
