defmodule ConstableWeb.UserAnnouncementTest do
  use ConstableWeb.AcceptanceCase

  test "user creates an announcement", %{session: session} do
    user = insert(:user)

    session
    |> visit(announcement_path(Endpoint, :new, as: user.id))
    |> fill_in("announcement_title", with: "Hello World")
    |> fill_in_interests("everyone")
    |> fill_in("announcement_body", with: "# Hello!")
    |> click_submit_button

    assert has_announcement_title?(session, "Hello World")
    assert has_announcement_body?(session, "Hello")
    assert has_announcement_interest?(session, "everyone")
  end

  test "user previews who will receive an announcement", %{session: session} do
    elixir_interest = insert(:interest, name: "elixir")
    _uninterested_user = insert(:user)
    _interested_user = insert(:user, name: "Paul") |> with_interest(elixir_interest)
    current_user = insert(:user, name: "Blake") |> with_interest(elixir_interest)

    session
    |> visit(announcement_path(Endpoint, :new, as: current_user.id))
    |> fill_in_interests("elixir")
    |> click_link("2 people are subscribed")

    assert has_recipient_preview?(session, "Blake, Paul")
  end

  test "user updates an announcement", %{session: session} do
    user = insert(:user)
    announcement = insert(:announcement, user: user)

    session
    |> visit(announcement_path(Endpoint, :show, announcement.id, as: user.id))
    |> click_edit
    |> fill_in("announcement_title", with: "Updated")
    |> fill_in_interests("updated")
    |> fill_in("announcement_body", with: "# Updated")
    |> click_submit_button

    assert has_announcement_title?(session, "Updated")
    assert has_announcement_interest?(session, "updated")
    assert has_announcement_body?(session, "Updated")
  end

  test "user edits an announcement and interests are kept", %{session: session} do
    user = insert(:user)
    elixir_interest = insert(:interest, name: "elixir")
    announcement = insert(:announcement, user: user) |> tag_with_interest(elixir_interest)

    session
    |> visit(announcement_path(Endpoint, :edit, announcement.id, as: user.id))
    |> fill_in("announcement_title", with: "Updated title")
    |> fill_in("announcement_body", with: "# Updated")
    |> click_submit_button

    assert has_announcement_title?(session, "Updated title")
    assert has_announcement_interest?(session, "elixir")
  end

  defp click_edit(session) do
    session
    |> find("[data-role=edit]")
    |> click

    session
  end

  defp fill_in_interests(session, interests) do
    session
    |> find(".selectize-input input")
    |> fill_in(with: interests)

    session
    |> find(".selectize-dropdown-content .create")
    |> click

    session
  end

  defp click_submit_button(session) do
    session
    |> find("[data-role=submit-announcement]")
    |> click
  end

  defp has_announcement_title?(session, text) do
    session |> find("h1[data-role=title]") |> has_text?(text)
  end

  defp has_announcement_body?(session, text) do
    session |> find("[data-role=body] h1") |> has_text?(text)
  end

  defp has_announcement_interest?(session, text) do
    session |> find("[data-role=interests]") |> has_text?(text)
  end

  defp has_recipient_preview?(session, user_names) do
    session |> find(".interested-user-names") |> has_text?(user_names)
  end
end
