defmodule AnnouncementChannelTest do
  use Constable.TestWithEcto, async: false
  import ChannelTestHelper
  alias Phoenix.Socket
  alias Constable.Repo
  alias Constable.AnnouncementChannel
  alias Constable.Serializers
  alias Constable.Queries

  test "announcements:index returns announcements with ids as the key" do
    user = Forge.saved_user(Repo)
    announcement = Forge.saved_announcement(Repo, user_id: user.id)
    |> preload_associations
    announcement_id = to_string(announcement.id)

    build_socket("announcements:index")
    |> handle_in(AnnouncementChannel)

    announcements = %{
      announcements: Map.put(%{}, announcement_id, announcement)
    }
    assert_socket_replied_with_payload("announcements:index", announcements)
  end

  test "announcements:index returns announcements with embedded comments" do
    user = Forge.saved_user(Repo)
    announcement = Forge.saved_announcement(Repo, user_id: user.id)
    Forge.saved_comment(Repo, announcement_id: announcement.id, user_id: user.id)
    announcement = announcement |> preload_associations
    announcement_id = to_string(announcement.id)

    build_socket("announcements:index")
    |> handle_in(AnnouncementChannel)

    announcements = %{
      announcements: Map.put(%{}, announcement_id, announcement)
    }
    assert_socket_replied_with_payload("announcements:index", announcements)
  end

  test "announcements:create returns an announcement" do
    user = Forge.saved_user(Repo)
    params = %{"title" => "Foo", "body" => "Bar", "interests" => []}

    authenticated_socket(user, "announcements:create")
    |> handle_in(AnnouncementChannel, params)

    announcement = Queries.Announcement.with_sorted_comments |> Repo.one
    assert_socket_broadcasted_with_payload("announcements:create", announcement)
  end

  defmodule FakeAnnouncementMailer do
    def created(announcement) do
      send self, {:new_announcement_email_sent, announcement}
    end
  end

  test "announcements:create adds interests and sends email" do
    user = Forge.saved_user(Repo)
    params = %{"title" => "Foo", "body" => "Bar", "interests" => ["foo"]}
    Pact.override(self, :announcement_mailer, FakeAnnouncementMailer)

    authenticated_socket(user, "announcements:create")
    |> handle_in(AnnouncementChannel, params)

    announcement = Queries.Announcement.with_sorted_comments |> Repo.one
    assert announcement_has_interest_named?(announcement, "foo")
    assert_received {:new_announcement_email_sent, ^announcement}
  end

  test "announcements:update returns an announcement" do
    user = Forge.saved_user(Repo)
    announcement = Forge.saved_announcement(Repo, user_id: user.id)
    params = %{"id" => announcement.id, "title" => "New!", "body" => "NEW!!!"}

    authenticated_socket(user, topic: "announcements:update")
    |> handle_in(AnnouncementChannel, params)

    announcement = Queries.Announcement.with_sorted_comments |> Repo.one
    assert_socket_broadcasted_with_payload("announcements:update", announcement)
  end

  test "announcements:update doesn't update when user doesn't own it" do
    user = Forge.saved_user(Repo)
    other_user = Forge.saved_user(Repo)
    announcement = Forge.saved_announcement(Repo, user_id: other_user.id)
    params = %{"id" => announcement.id, "title" => "New!", "body" => "NEW!!!"}

    authenticated_socket(user, topic: "announcements:update")
    |> handle_in(AnnouncementChannel, params)

    refute_received {:socket_broadcast, _payload }
  end

  defp preload_associations(announcement) do
    Repo.preload(announcement, [:interests, :user, comments: :user])
  end

  defp announcement_has_interest_named?(announcement, interest_name) do
    announcement.interests |> List.first |> Map.get(:name) == interest_name
  end
end
