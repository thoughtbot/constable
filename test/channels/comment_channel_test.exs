defmodule CommentChannelTest do
  use Constable.TestWithEcto, async: false
  import Ecto.Query
  import ChannelTestHelper
  require Pact
  alias Constable.Announcement
  alias Constable.Repo
  alias Constable.Comment
  alias Constable.CommentChannel
  alias Constable.Serializers

  test "comments:create broadcasts comments:create with new comment" do
    user = Forge.saved_user(Repo)
    announcement = Forge.saved_announcement(Repo, user_id: user.id)

    Phoenix.PubSub.subscribe(Constable.PubSub, self, "comments:create")
    socket_with_topic("comments:create")
    |> assign_current_user(user.id)
    |> handle_in_topic(CommentChannel, comment_params_for(announcement))

    comment = Repo.one(from c in Comment, preload: :user) |> Serializers.to_json
    assert_socket_broadcasted_with_payload("comments:create", comment)
  end

  test "comments:create updates the announcements timestamp" do
    user = Forge.saved_user(Repo)
    {:ok, date} = Ecto.DateTime.load({{2000, 12, 25}, {11, 42, 42}})
    announcement = Forge.saved_announcement(
      Repo,
      user_id: user.id,
      updated_at: date
    )

    Phoenix.PubSub.subscribe(Constable.PubSub, self, "comments:create")
    socket_with_topic("comments:create")
    |> assign_current_user(user.id)
    |> handle_in_topic(CommentChannel, comment_params_for(announcement))

    updated_announcement = Repo.get(Announcement, announcement.id)
    assert announcement.updated_at != updated_announcement.updated_at
  end

  test "comments:create emails subscribers of the announcement" do
    user = Forge.saved_user(Repo)
    Forge.saved_user(Repo)
    announcement = Forge.saved_announcement(Repo, user_id: user.id)
    Forge.saved_subscription(
      Repo,
      user_id: user.id,
      announcement_id: announcement.id
    )
    Pact.replace self, :comment_mailer do
      def created(comment, users) do
        send self, {:comment, comment}
        send self, {:users, users}
      end
    end

    socket_with_topic("comments:create")
    |> assign_current_user(user.id)
    |> handle_in_topic(CommentChannel, comment_params_for(announcement))

    comment = Repo.one(from c in Comment, preload: [:user, :announcement])

    assert_received {:users, [^user]}
    assert_received {:comment, ^comment}
  end

  def comment_params_for(announcement) do
    %{
      "announcement_id" => announcement.id,
      "body" => "Bar"
    }
  end
end
