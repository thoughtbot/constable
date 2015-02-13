defmodule ConstableApi.Serializers.CommentTest do
  use ExUnit.Case, async: true
  alias ConstableApi.Serializers

  test "returns map with comment id and body" do
    user = Forge.user
    comment = Forge.comment(id: 1, user: user)

    comment_as_json = Serializers.to_json(comment)

    assert comment_as_json == %{
      id: comment.id,
      body: comment.body,
      user: Serializers.to_json(comment.user),
      announcement_id: comment.announcement_id,
      inserted_at: Ecto.DateTime.to_string(comment.inserted_at)
    }
  end
end
