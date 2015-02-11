defmodule CommentChannelTest do
  use ConstableApi.TestWithEcto, async: false

  import ChannelTestHelper
  alias ConstableApi.Repo
  alias ConstableApi.Announcement
  alias ConstableApi.Comment
  alias ConstableApi.CommentChannel
  alias ConstableApi.Serializers

  test "comments:create broadcasts comments:create with new comment" do
    announcement = %Announcement{title: "foo", body: "bar"} |> Repo.insert
    Phoenix.PubSub.subscribe(self, "comments:create")
    comment_params = %{
      "announcement_id" => announcement.id,
      "body" => "Bar"
    }

    handle_in_topic(CommentChannel, "comments:create", comment_params)

    comment = Repo.one(Comment) |> Serializers.to_json
    assert_socket_broadcasted_with_payload("comments:create", comment)
  end
end
