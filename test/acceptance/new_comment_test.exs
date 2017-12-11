defmodule ConstableWeb.NewCommentTest do
  use ConstableWeb.AcceptanceCase

  test "new comments are displayed in real time", %{session: session} do
    {:ok, other_session} = Wallaby.start_session
    [announcement, other_announcement] = insert_pair(:announcement)
    user = insert(:user)

    session
    |> visit(announcement_path(Endpoint, :show, announcement, as: user.id))
    |> fill_in("comment_body", with: "My Cool Comment")
    |> submit_comment

    other_session
    |> visit(announcement_path(Endpoint, :show, other_announcement, as: user.id))

    assert has_comment_text?(session, "My Cool Comment")
    refute has_comment_text?(other_session, "My Cool Comment")
  end

  defp submit_comment(session) do
    session
    |> find("#submit-comment")
    |> click
  end

  defp has_comment_text?(session, comment_text) do
    find(session, ".comments-list") |> has_text?(comment_text)
  end
end
