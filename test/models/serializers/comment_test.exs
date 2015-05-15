defmodule Constable.CommentSerializerTest do
  use ExUnit.Case, async: true
  alias Constable.Serializers

  test "returns json with comment id and body" do
    user = Forge.user
    comment = Forge.comment(id: 1, user: user)

    comment_as_json = Poison.encode!(comment)

    assert comment_as_json == Poison.encode! %{
      id: comment.id,
      body: comment.body,
      user_id: comment.user_id,
      announcement_id: comment.announcement_id,
      inserted_at: comment.inserted_at
    }
  end
end
