defmodule CommentTest do
  use ConstableApi.TestWithEcto, async: false
  alias ConstableApi.Comment
  alias ConstableApi.Repo
  alias ConstableApi.Serializers

  test "returns map with comment id and body" do
    comment = %Comment{body: "foo"} |> Repo.insert

    comment_as_json = Serializers.to_json(comment)

    assert comment_as_json == %{
      id: comment.id,
      body: comment.body,
      announcement_id: comment.announcement_id
    }
  end
end
