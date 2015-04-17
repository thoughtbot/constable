defmodule ChannelTestHelper do
  import ExUnit.Assertions
  alias Phoenix.Socket
  alias Phoenix.Socket.Message
  alias Constable.Router
  alias Constable.Endpoint
  alias Phoenix.Channel.Transport
  alias Phoenix.Transports.WebSocket

  # New stuff

  def assert_replied(status, topic, payload) do
    assert_receive {:socket_push, %Message{event: "phx_reply", payload: %{
      ref: "1234", response: ^payload, status: ^status}, topic: ^topic}}
  end

  def assert_broadcasted(topic, event, payload) do
    assert_receive {:socket_push, %Message{
      event: ^event,
      payload: socket_payload,
      topic: ^topic
    }}
    assert socket_payload == payload
  end

  def dispatch(socket_pid, topic, event, params = %{}) do
    sockets = HashDict.put(HashDict.new, topic, socket_pid)
    %Message{event: event,
             topic: "announcements",
             ref: "1234",
             payload: params}
    |> Transport.dispatch(sockets, self, Router, Endpoint, WebSocket)
  end

  def join(topic, params) do
    message = join_message(topic, params)
    {:ok, socket_pid} = Transport.dispatch(message, HashDict.new, self, Router, Endpoint, WebSocket)
    socket_pid
  end

  def join_message(topic, payload) do
    Forge.join_message(topic: topic, payload: payload)
  end

  # Old stuff

  def handle_join(channel, params, socket) do
    channel.join("", params, socket)
  end

  def handle_in(socket, channel, event, params \\ %{}) do
    channel.handle_in(event, params, socket)
  end

  def assert_socket_broadcasted_with_payload(topic, payload) do
    assert_receive {
      :socket_broadcast,
      %Socket.Message{event: ^topic, payload: ^payload, topic: ^topic}
    }
  end

  def replied(status, payload, response) do
    {:reply, {^status, ^payload}, _} = response
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
