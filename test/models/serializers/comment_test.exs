defmodule CommentTest do
  use ConstableApi.TestWithEcto, async: false
  alias ConstableApi.Serializers

  test "returns map with comment id and body" do
    comment = Forge.comment(id: 1)

    comment_as_json = Serializers.to_json(comment)

    assert comment_as_json == %{
      id: comment.id,
      body: comment.body,
      announcement_id: comment.announcement_id
    }
  end
end
