defmodule Constable.Services.AnnouncementCreatorTest do
  use Constable.TestWithEcto, async: false

  alias Constable.Announcement
  alias Constable.Subscription
  alias Constable.Services.AnnouncementCreator

  defmodule FakeAnnouncementMailer do
    def created(announcement, users) do
      send self, {:announcement, announcement}
      send self, {:users, users}
    end
  end

  setup do
    Pact.override self, :announcement_mailer, __MODULE__.FakeAnnouncementMailer
    {:ok, %{}}
  end

  test "creates an announcement with new and existing interests" do
    author = create(:user)
    existing_interest = create(:interest)
    new_interest_name = "foo"
    interest_name_with_hash = "#everyone"
    duplicate_interest = "#foo"
    interest_names =
      [existing_interest.name, new_interest_name, interest_name_with_hash, duplicate_interest]
    announcement_params = build(:announcement_params, user: author)

    AnnouncementCreator.create(announcement_params, interest_names)

    announcement = Repo.one(Announcement) |> Repo.preload([:interests])
    assert announcement_has_interest_named?(announcement, new_interest_name)
    assert announcement_has_interest_named?(announcement, existing_interest.name)
    assert announcement_has_interest_named?(announcement, "everyone")
    refute announcement_has_interest_named?(announcement, duplicate_interest)
  end

  test "subscribes the author to the newly created announcement" do
    author = create(:user)
    announcement_params = build(:announcement_params, user: author)

    AnnouncementCreator.create(announcement_params, [])

    announcement = Repo.one(Announcement)
    subscription = Repo.one(Subscription)
    assert subscription.user_id == author.id
    assert subscription.announcement_id == announcement.id
  end

  test "does not create blank interests" do
    interest_names = [""]
    announcement_params = build(:announcement_params)

    AnnouncementCreator.create(announcement_params, interest_names)

    announcement = Repo.one(Announcement) |> Repo.preload([:interests])
    assert announcement.interests == []
  end

  test "subscribes interested users when autosubscribe is on" do
    auto_subscribe_user = create(:user, auto_subscribe: true)
    user = create(:user, auto_subscribe: false)
    creator = create(:user)
    interest = create(:interest, name: "foo")
    create(:user_interest, user: user, interest: interest)
    create(:user_interest, user: auto_subscribe_user, interest: interest)

    announcement_params = %{
      title: "Title",
      body: "Body",
      user_id: creator.id
    }

    AnnouncementCreator.create(announcement_params, "foo")
    announcement = Repo.one(Announcement)

    refute Repo.get_by(Subscription,
      user_id: user.id,
      announcement_id: announcement.id
    )
    assert Repo.get_by(Subscription,
      user_id: auto_subscribe_user.id,
      announcement_id: announcement.id
    )
  end

  test "sends announcement email" do
    user = create(:user)
    interest = create(:interest, name: "foo")
    create(:user_interest, user: user, interest: interest)

    announcement_params = %{
      title: "Title",
      body: "Body",
      user_id: user.id
    }

    AnnouncementCreator.create(announcement_params, ["foo"])

    announcement = Repo.one(Announcement)
    assert_received {:announcement, ^announcement}
    assert_received {:users, [^user]}
  end

  defp announcement_has_interest_named?(announcement, interest_name) do
    announcement.interests |> Enum.any?(&(&1.name == interest_name))
  end
end
