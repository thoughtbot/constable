defmodule Constable.CommentTest do
  use Constable.ModelCase, async: true
  alias Constable.Comment
  import GoodTimes

  test "when a comment is inserted, it updates the announcement last_discussed_at" do
    announcement = create_announcement_last_discussed(a_week_ago)
    now = DateTime.utc_now

    comment = insert_comment_on_announcement(announcement, now)

    assert comment.announcement.last_discussed_at == now
  end

  defp create_announcement_last_discussed(time_ago) do
    insert(:announcement, last_discussed_at: Constable.Time.cast!(time_ago))
  end

  defp insert_comment_on_announcement(announcement, last_discussed_at) do
    comment_params = %{
      announcement_id: announcement.id,
      body: "Anything",
      user_id: insert(:user).id
    }

    Comment.create_changeset(%Comment{}, comment_params, last_discussed_at)
    |> Repo.insert!
    |> Repo.preload(:announcement)
  end
end
