defmodule AnnouncementChannelTest do
  use ConstableApi.TestWithEcto, async: false
  import ChannelTestHelper
  alias Phoenix.Socket
  alias ConstableApi.Repo
  alias ConstableApi.AnnouncementChannel
  alias ConstableApi.Serializers
  alias ConstableApi.Queries

  test "announcements:index returns announcements with ids as the key" do
    user = Forge.saved_user(Repo)
    announcement = Forge.saved_announcement(Repo, user_id: user.id)
    |> Repo.preload([:comments, :user])
    announcement_id = to_string(announcement.id)

    socket_with_topic("announcements:index")
    |> handle_in_topic(AnnouncementChannel)

    announcements = %{
      announcements:
      Map.put(%{}, announcement_id, Serializers.to_json(announcement))
    }

    assert_socket_replied_with_payload("announcements:index", announcements)
  end

  test "announcements:index returns announcements with embedded comments" do
    user = Forge.saved_user(Repo)
    announcement = Forge.saved_announcement(Repo, user_id: user.id)
    Forge.saved_comment(Repo, announcement_id: announcement.id, user_id: user.id)
    announcement = announcement |> Repo.preload([:user, comments: :user])
    announcement_id = to_string(announcement.id)

    socket_with_topic("announcements:index")
    |> handle_in_topic(AnnouncementChannel)

    announcements = %{
      announcements:
      Map.put(%{}, announcement_id, Serializers.to_json(announcement))
    }
    assert_socket_replied_with_payload("announcements:index", announcements)
  end

  test "announcements:create returns an announcement" do
    user = Forge.saved_user(Repo)
    params = %{"title" => "Foo", "body" => "Bar"}
    Phoenix.PubSub.subscribe(self, "announcements:create")

    socket_with_topic("announcements:create")
    |> Socket.assign(:current_user_id, user.id)
    |> handle_in_topic(AnnouncementChannel, params)

    announcement =
      Queries.Announcement.with_sorted_comments
      |> Repo.one
      |> Serializers.to_json
    assert_socket_broadcasted_with_payload("announcements:create", announcement)
  end
end
