defmodule ConstableWeb.UserSetsSlackChannelForInterestTest do
  use ConstableWeb.AcceptanceCase

  test "user adds the slack channel for an interest", %{session: session} do
    interest = insert(:interest, name: "interest")
    user = insert(:user)

    session
    |> visit(interest_path(Endpoint, :show, interest, as: user.id))
    |> click_edit_interest
    |> fill_in("interest_slack_channel", with: "#channel-name")
    |> click_submit

    assert has_slack_channel_set?(session, "#channel-name")
  end

  test "user edits an existing slack channel for an interest", %{session: session} do
    interest = insert(:interest, name: "interest", slack_channel: "#channel-name")
    user = insert(:user)

    visit(session, interest_path(Endpoint, :show, interest, as: user.id))

    assert has_slack_channel_set?(session, "#channel-name")

    session
    |> click_edit_interest
    |> fill_in("interest_slack_channel", with: "#new-channel-name")
    |> click_submit

    assert has_slack_channel_set?(session, "#new-channel-name")
  end

  test "user removes an existing slack channel for an interest", %{session: session} do
    interest = insert(:interest, name: "interest", slack_channel: "#channel-name")
    user = insert(:user)

    session
    |> visit(interest_slack_channel_path(Endpoint, :edit, interest, as: user.id))
    |> accept_all_confirm_dialogs
    |> click_remove_slack_channel

    assert has_no_slack_channel_set?(session)
  end

  defp click_remove_slack_channel(session) do
    session
    |> click("a[data-role=remove-channel]")
  end

  defp click_edit_interest(session) do
    session
    |> find("a[data-role=edit-interest]")
    |> click

    session
  end

  defp has_slack_channel_set?(session, channel_name) do
    session
    |> find("[data-role=current-channel]")
    |> has_text?(channel_name)
  end

  defp has_no_slack_channel_set?(session) do
    session
    |> find("[data-role=current-channel]")
    |> has_text?("add a slack channel")
  end

  defp click_submit(session) do
    session
    |> find("#submit-channel-name")
    |> click
  end
end
