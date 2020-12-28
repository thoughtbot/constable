defmodule ConstableWeb.NewCommentTest do
  use ConstableWeb.AcceptanceCase

  test "new comments are displayed in real time", %{session: session} do
    {:ok, other_session} = Wallaby.start_session()
    [announcement, other_announcement] = insert_pair(:announcement)
    user = insert(:user)

    session
    |> visit(Routes.announcement_path(Endpoint, :show, announcement, as: user.id))
    |> fill_in(text_field("comment_body"), with: "My Cool Comment")
    |> click(button("Post Comment"))

    other_session
    |> visit(Routes.announcement_path(Endpoint, :show, other_announcement, as: user.id))

    session
    |> assert_has(comment_text("My Cool Comment"))
    |> refute_has(comments_placeholder())

    other_session
    |> refute_has(comment_text("My Cool Comment"))
  end

  defp comment_text(comment_text) do
    css(".comments-list", text: comment_text)
  end

  defp comments_placeholder do
    css(".comments-placeholder", count: 1)
  end
end
