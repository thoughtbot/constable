defmodule ChannelTestHelper do
  import ExUnit.Assertions
  alias Phoenix.Socket

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

  def handle_join(channel, params, socket) do
    channel.join("", params, socket)
  end

  def socket_with_topic(topic \\ "") do
    Socket.put_current_topic(new_socket(topic), topic)
  end

  def handle_in_topic(channel, topic, params \\ %{}) do
    channel.handle_in(topic, params, socket_with_topic(topic))
  end

  def new_socket(topic) do
    %Socket{
      pid: self,
      router: ConstableApi.Router,
      topic: topic,
      assigns: []
    }
  end
end
