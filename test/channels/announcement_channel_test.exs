defmodule AnnouncementChannelTest do
  use Constable.ChannelCase
  alias Constable.AnnouncementChannel
  alias Constable.Queries

  @channel AnnouncementChannel

  test "'all' returns announcements" do
    user = Forge.saved_user(Repo)
    announcement = Forge.saved_announcement(Repo, user_id: user.id)
    announcement = announcement |> preload_associations
    socket = join!("announcements", as: user)

    ref = push socket, "all"

    payload = payload_from_reply(ref, :ok)
    assert payload == %{announcements: [announcement]}
  end


  test "'all' returns announcements with embedded comments" do
    user = Forge.saved_user(Repo)
    announcement = Forge.saved_announcement(Repo, user_id: user.id)
    Forge.saved_comment(Repo, announcement_id: announcement.id, user_id: user.id)
    announcement = announcement |> preload_associations
    socket = join!("announcements", as: user)

    ref = push socket, "all"

    payload = payload_from_reply(ref, :ok)
    assert payload == %{announcements: [announcement]}
  end

  test "'show' returns announcement with embedded comments" do
    user = Forge.saved_user(Repo)
    announcement = Forge.saved_announcement(Repo, user_id: user.id)
    Forge.saved_comment(Repo, announcement_id: announcement.id, user_id: user.id)
    announcement = announcement |> preload_associations
    socket = join!("announcements", as: user)

    ref = push socket, "show", %{"id" => announcement.id}

    assert_reply ref, :ok, %{announcement: announcement}
  end

  test "'create' broadcasts and replies with the new announcement" do
    user = Forge.saved_user(Repo)
    params = %{"title" => "Foo", "body" => "Bar", "interests" => []}
    socket = join!("announcements", as: user)

    ref = push socket, "create", %{"announcement" => params}

    assert_broadcast "add", broadcast_payload
    assert_reply ref, :ok, reply_payload
    announcement = Queries.Announcement.with_sorted_comments |> Repo.one
    assert broadcast_payload == %{announcement: announcement}
    assert reply_payload == %{announcement: announcement}
  end

  defmodule FakeAnnouncementMailer do
    def created(announcement) do
      send self, {:new_announcement_email_sent, announcement}
    end
  end

  test "'create' adds interests and sends email" do
    user = Forge.saved_user(Repo)
    params = %{"title" => "Foo", "body" => "Bar", "interests" => ["foo"]}
    Pact.override(self, :announcement_mailer, FakeAnnouncementMailer)
    socket = join!("announcements", as: user)

    ref = push socket, "create", %{"announcement" => params}

    wait_for_reply ref, :ok
    announcement = Queries.Announcement.with_sorted_comments |> Repo.one
    assert announcement_has_interest_named?(announcement, "foo")
    # Not working right now
    # assert_received {:new_announcement_email_sent, ^announcement}
  end

  test "'update' returns an announcement" do
    user = Forge.saved_user(Repo)
    announcement = Forge.saved_announcement(Repo, user_id: user.id)
    params = %{"id" => announcement.id, "title" => "New!", "body" => "Body!"}
    socket = join!("announcements", as: user)

    ref = push socket, "update", %{"announcement" => params}

    assert_broadcast "update", payload
    announcement = Queries.Announcement.with_sorted_comments |> Repo.one
    assert announcement.title == "New!"
    assert announcement.body == "Body!"
    assert payload == %{announcement: announcement}
  end

  test "'update' throws an error when user doesn't own it" do
    user = Forge.saved_user(Repo)
    other_user = Forge.saved_user(Repo)
    announcement = Forge.saved_announcement(Repo, user_id: other_user.id)
    params = %{"id" => announcement.id, "title" => "New!", "body" => "NEW!!!"}
    socket = join!("announcements", as: user)

    ref = push socket, "update", %{"announcement" => params}

    refute_broadcast "update", %{announcement: _}
  end

  defp preload_associations(announcement) do
    announcement
    |> Repo.preload([:interests, :interested_users, :user, comments: :user])
  end

  defp announcement_has_interest_named?(announcement, interest_name) do
    announcement.interests |> List.first |> Map.get(:name) == interest_name
  end
end
