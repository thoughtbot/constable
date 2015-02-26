defmodule ChannelTestHelper do
  import ExUnit.Assertions
  alias Phoenix.Socket

  def handle_join(channel, params, socket) do
    channel.join("", params, socket)
  end

  def handle_in_topic(socket, channel, params \\ %{}) do
    channel.handle_in(socket.topic, params, socket)
  end

  def assert_socket_broadcasted_with_payload(topic, payload) do
    assert_received {
      :socket_broadcast,
      %Socket.Message{event: ^topic, payload: ^payload, topic: ^topic}
    }
  end

  def assert_socket_replied_with_payload(topic, payload) do
    assert_received {
      :socket_reply,
      %Socket.Message{event: ^topic, payload: ^payload, topic: ^topic}
    }
  end

  def assign_current_user(socket, user_id) do
    Socket.assign(socket, :current_user_id, user_id)
  end

  def socket_with_topic(topic \\ "") do
    Socket.put_topic(new_socket(topic), topic)
  end

  defp new_socket(topic) do
    %Socket{
      pid: self,
      router: Constable.Router,
      topic: topic,
      pubsub_server: Constable.PubSub,
      assigns: []
    }
  end
end
