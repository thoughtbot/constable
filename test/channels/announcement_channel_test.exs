defmodule AnnouncementChannelTest do
  use Constable.TestWithEcto, async: false
  import ChannelTestHelper
  alias Constable.Repo
  alias Constable.AnnouncementChannel
  alias Constable.Serializers
  alias Constable.Queries

  test "announcements:index returns announcements with ids as the key" do
    user = Forge.saved_user(Repo)
    announcement = Forge.saved_announcement(Repo, user_id: user.id)
    announcement = announcement |> preload_associations

    join("announcements", %{"token" => user.token})
    |> dispatch("announcements", "all", %{})

    assert_replied "ok", "announcements", %{announcements: [announcement]}
  end


  test "announcements:index returns announcements with embedded comments" do
    user = Forge.saved_user(Repo)
    announcement = Forge.saved_announcement(Repo, user_id: user.id)
    Forge.saved_comment(Repo, announcement_id: announcement.id, user_id: user.id)
    announcement = announcement |> preload_associations

    join("announcements", %{"token" => user.token})
    |> dispatch("announcements", "all", %{})

    assert_replied "ok", "announcements", %{announcements: [announcement]}
  end

  test "announcements:show returns announcement with embedded comments" do
    user = Forge.saved_user(Repo)
    announcement = Forge.saved_announcement(Repo, user_id: user.id)
    Forge.saved_comment(Repo, announcement_id: announcement.id, user_id: user.id)
    announcement = announcement |> preload_associations

    join("announcements", %{"token" => user.token})
    |> dispatch("announcements", "show", %{"id" => announcement.id})

    assert_replied "ok", "announcements", %{announcement: announcement}
  end

  test "announcements:create returns an announcement" do
    user = Forge.saved_user(Repo)
    params = %{"title" => "Foo", "body" => "Bar", "interests" => []}

    join("announcements", %{"token" => user.token})
    |> dispatch("announcements", "create", %{"announcement" => params})

    :timer.sleep(300)
    announcement = Queries.Announcement.with_sorted_comments |> Repo.one
    announcements = Repo.all(Constable.Announcement) |> IO.inspect
    assert_broadcasted "announcements", "add", announcement
    assert_replied "ok", "announcements", %{announcement: announcement}
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

    join("announcements", %{"token" => user.token})
    |> dispatch("announcements", "create", %{"announcement" => params})

    :timer.sleep(300)
    announcement = Queries.Announcement.with_sorted_comments |> Repo.one
    assert announcement_has_interest_named?(announcement, "foo")
  end

  test "announcements:update returns an announcement" do
    user = Forge.saved_user(Repo)
    announcement = Forge.saved_announcement(Repo, user_id: user.id)
    params = %{"id" => announcement.id, "title" => "New!", "body" => "NEW!!!"}

    join("announcements", %{"token" => user.token})
    |> dispatch("announcements", "update", %{"announcement" => params})

    :timer.sleep(300)
    announcement = Queries.Announcement.with_sorted_comments |> Repo.one
    assert_broadcasted("announcements", "update", %{announcement: announcement})
  end

  test "announcements:update doesn't update when user doesn't own it" do
    user = Forge.saved_user(Repo)
    other_user = Forge.saved_user(Repo)
    announcement = Forge.saved_announcement(Repo, user_id: other_user.id)
    params = %{"id" => announcement.id, "title" => "New!", "body" => "NEW!!!"}

    join("announcements", %{"token" => user.token})
    |> dispatch("announcements", "update", %{"announcement" => params})

    refute_received {:socket_push, %Phoenix.Socket.Message{event: "update"}}
  end

  defp preload_associations(announcement) do
    Repo.preload(announcement, [:interests, :user, comments: :user])
  end

  defp announcement_has_interest_named?(announcement, interest_name) do
    announcement.interests |> List.first |> Map.get(:name) == interest_name
  end
end
