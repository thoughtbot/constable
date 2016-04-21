defmodule Constable.UserViewsInterestPageTest do
  use Constable.AcceptanceCase

  test "user views interest page", %{session: session} do
    matching_interest = create(:interest, name: "foobar1s")
    matching_announcement = create(:announcement, title: "foobar1")
      |> tag_with_interest(matching_interest)
    _non_matching_announcement = create(:announcement, title: "foobar2")
    user = create(:user)

    session
    |> visit(interest_path(Endpoint, :show, matching_interest, as: user.id))

    assert has_announcement_text?(session, matching_announcement.title)
    assert find(session, ".announcement-list", count: 1)
  end

  test "user adds the slack channel for an interest", %{session: session} do
    interest = create(:interest, name: "interest")
    user = create(:user)

    session
    |> visit(interest_path(Endpoint, :show, interest.id, as: user.id))
    |> click_edit_interest
    |> fill_in("interest_slack_channel", with: "#channel-name")
    |> click_submit

    assert has_channel_text?(session, "#channel-name")
  end

  test "user edits an existing slack channel for an interest", %{session: session} do
    interest = create(:interest, name: "interest", slack_channel: "#channel-name")
    user = create(:user)

    visit(session, interest_path(Endpoint, :show, interest, as: user.id))

    assert has_channel_text?(session, "#channel-name")

    session
    |> click_edit_interest
    |> fill_in("interest_slack_channel", with: "#new-channel-name")
    |> click_submit

    assert has_channel_text?(session, "#new-channel-name")
  end

  defp has_announcement_text?(session, announcment_title) do
    session
    |> find("h1[data-role=title]")
    |> has_text?(announcment_title)
  end

  defp click_edit_interest(session) do
    session
    |> find("a[data-role=edit-interest]")
    |> click

    session
  end

  defp has_channel_text?(session, channel_name) do
    session
    |> find("p[data-role=current-channel]")
    |> has_text?(channel_name)
  end

  defp click_submit(session) do
    session
    |> find("#submit-channel-name")
    |> click
  end
end
