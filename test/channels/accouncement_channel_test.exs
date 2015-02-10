defmodule AnnouncementChannelTest do
  use ConstableApi.TestWithEcto, async: false

  import ChannelTestHelper
  alias ConstableApi.Repo
  alias ConstableApi.Announcement
  alias ConstableApi.AnnouncementChannel
  alias ConstableApi.Comment
  alias ConstableApi.Serializers

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
end
