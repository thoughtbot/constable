defmodule AnnouncementChannelTest do
  use ConstableApi.TestWithEcto, async: false

  alias Phoenix.Socket
  alias ConstableApi.Repo
  alias ConstableApi.Announcement
  alias ConstableApi.AnnouncementChannel

  test "announcements:index returns announcements with ids as the key" do
    announcement = %Announcement{title: "Foo", body: "Bar"} |> Repo.insert
    announcement_id = to_string(announcement.id)

    handle_in_topic(AnnouncementChannel, "announcements:index")

    announcements = %{} |> Map.put(announcement_id, announcement)
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
      %Socket.Message{event: topic, payload: payload, topic: topic}
    }
  end

  def assert_socket_replied_with_payload(topic, payload) do
    assert_received {
      :socket_reply,
      %Socket.Message{event: topic, payload: payload, topic: topic}
    }
  end

  def handle_in_topic(channel, topic, params \\ %{}) do
    socket = Socket.put_current_topic(new_socket(topic), topic)
    channel.handle_in(topic, params, socket)
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
