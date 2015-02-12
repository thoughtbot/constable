defmodule CommentChannelTest do
  use ConstableApi.TestWithEcto, async: false
  import Ecto.Query
  import ChannelTestHelper
  alias ConstableApi.Repo
  alias ConstableApi.Comment
  alias ConstableApi.CommentChannel
  alias ConstableApi.Serializers

  test "comments:create broadcasts comments:create with new comment" do
    user = Forge.saved_user(Repo)
    announcement = Forge.saved_announcement(Repo, user_id: user.id)
    Phoenix.PubSub.subscribe(self, "comments:create")
    comment_params = %{
      "announcement_id" => announcement.id,
      "body" => "Bar"
    }

    socket_with_topic("comments:create")
    |> assign_current_user(user.id)
    |> handle_in_topic(CommentChannel, comment_params)

    comment = Repo.one(from c in Comment, preload: :user) |> Serializers.to_json
    assert_socket_broadcasted_with_payload("comments:create", comment)
  end
end
