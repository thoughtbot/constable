defmodule Constable.UserSearchesAnnouncementsTest do
  use Constable.AcceptanceCase, async: true

  test "user performs search", %{session: session} do
    matching_announcement = create(:announcement, title: "foobar1")
    non_matching_announcement = create(:announcement, title: "foobar2")
    user = create(:user)

    session
    |> visit(search_path(Endpoint, :new, as: user.id))
    |> fill_in("query", with: matching_announcement.title)
    |> click_search_button

    assert has_announcement_text?(session, matching_announcement.title)
    refute has_announcement_text?(session, non_matching_announcement.title)
  end

  defp click_search_button(session) do
    session
    |> find("#submit-search")
    |> click
  end

  defp has_announcement_text?(session, announcment_title) do
    session
    |> find("h1[data-role=title]")
    |> has_text?(announcment_title)
  end
end
