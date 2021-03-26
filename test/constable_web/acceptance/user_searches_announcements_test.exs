defmodule ConstableWeb.UserSearchesAnnouncementsTest do
  use ConstableWeb.AcceptanceCase

  test "user performs search", %{session: session} do
    matching_announcement = insert(:announcement, title: "foobar1")
    non_matching_announcement = insert(:announcement, title: "foobar2")
    user = insert(:user)

    session
    |> visit(Routes.announcement_path(Endpoint, :new, as: user.id))
    |> fill_in(text_field("query"), with: matching_announcement.title)
    |> submit_search

    assert has_announcement_text?(session, matching_announcement.title)
    refute has_announcement_text?(session, non_matching_announcement.title)
  end

  defp submit_search(session) do
    session
    |> execute_script("$('.app-header__search-input').parent().trigger('submit')")

    session
  end

  defp has_announcement_text?(session, announcment_title) do
    session
    |> find(css("[data-role=title]"))
    |> has_text?(announcment_title)
  end
end
