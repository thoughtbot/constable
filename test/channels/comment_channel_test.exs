defmodule CommentChannelTest do
  use ConstableApi.TestWithEcto, async: false
  import Ecto.Query
  import ChannelTestHelper
  alias ConstableApi.Announcement
  alias ConstableApi.Repo
  alias ConstableApi.Comment
  alias ConstableApi.CommentChannel
  alias ConstableApi.Serializers

  test "comments:create broadcasts comments:create with new comment" do
    Pact.override(self, :comment_mailer, FakeCommentMailer)
    user = Forge.saved_user(Repo)
    announcement = Forge.saved_announcement(Repo, user_id: user.id)

    Phoenix.PubSub.subscribe(self, "comments:create")
    socket_with_topic("comments:create")
    |> assign_current_user(user.id)
    |> handle_in_topic(CommentChannel, comment_params_for(announcement))

    comment = Repo.one(from c in Comment, preload: :user) |> Serializers.to_json
    assert_socket_broadcasted_with_payload("comments:create", comment)
  end

  test "comments:create updates the announcements timestamp" do
    Pact.override(self, :comment_mailer, FakeCommentMailer)
    user = Forge.saved_user(Repo)
    {:ok, date} = Ecto.DateTime.load({{2000, 12, 25}, {11, 42, 42}})
    announcement = Forge.saved_announcement(
      Repo,
      user_id: user.id,
      updated_at: date
    )

    Phoenix.PubSub.subscribe(self, "comments:create")
    socket_with_topic("comments:create")
    |> assign_current_user(user.id)
    |> handle_in_topic(CommentChannel, comment_params_for(announcement))

    updated_announcement = Repo.get(Announcement, announcement.id)
    assert announcement.updated_at != updated_announcement.updated_at
  end

  def comment_params_for(announcement) do
    comment_params = %{
      "announcement_id" => announcement.id,
      "body" => "Bar"
    }
  end
end
