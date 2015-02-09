defmodule AnnouncementChannelTest do
  use ConstableApi.TestWithEcto, async: false

  alias Phoenix.Socket
  alias ConstableApi.Repo
  alias ConstableApi.Announcement
  alias ConstableApi.AnnouncementChannel
  alias ConstableApi.User
  alias ConstableApi.Comment
  alias ConstableApi.Serializers

  test "joins the socket when the auth token matches a user" do
    user = %User{email: "foo@bar.com"} |> Repo.insert
    socket = socket_with_topic

    {status, socket} =
      handle_join(AnnouncementChannel, %{"token" => user.token}, socket)

    assert status == :ok
    assert socket == socket
  end

  test "returns error when joining with an incorrect token" do
    %User{email: "foo@bar.com"} |> Repo.insert
    bad_token = "abc"
    socket = socket_with_topic

    {status, socket, message} =
      handle_join(AnnouncementChannel, %{"token" => bad_token}, socket)

    assert status == :error
    assert socket == socket
    assert message == :unauthorized
  end

  test "announcements:index returns announcements with ids as the key" do
    announcement = %Announcement{title: "Foo", body: "Bar"}
    |> Repo.insert
    |> Repo.preload(:comments)
    announcement_id = to_string(announcement.id)

    handle_in_topic(AnnouncementChannel, "announcements:index")

    announcements = %{
      announcements:
      Map.put(%{}, announcement_id, Serializers.to_json(announcement))
    }
    assert_socket_replied_with_payload("announcements:index", announcements)
  end

  test "announcements:index returns announcements with embedded comments" do
    announcement = %Announcement{title: "Foo", body: "Bar"} |> Repo.insert
    %Comment{body: "foo", announcement_id: announcement.id} |> Repo.insert
    announcement = announcement |> Repo.preload(:comments)
    announcement_id = to_string(announcement.id)

    handle_in_topic(AnnouncementChannel, "announcements:index")

    announcements = %{
      announcements:
      Map.put(%{}, announcement_id, Serializers.to_json(announcement))
    }
    assert_socket_replied_with_payload("announcements:index", announcements)
  end

  test "announcements:create returns an announcement" do
    params = %{"title" => "Foo", "body" => "Bar"}
    Phoenix.PubSub.subscribe(self, "announcements:create")

    handle_in_topic(AnnouncementChannel, "announcements:create", params)

    announcement = Repo.one(Announcement)
    assert_socket_broadcasted_with_payload("announcements:create", announcement)
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
