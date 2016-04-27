defmodule Constable.UserCreatesAnnouncementTest do
  use Constable.AcceptanceCase, async: true

  @tag pending: true
  test "user creates an announcement", %{session: session} do
    user = create(:user)

    session
    |> visit(announcement_path(Endpoint, :new, as: user.id))
    |> fill_in("announcement_title", with: "Hello World")
    |> fill_in("announcement_interests", with: "everyone")
    |> fill_in("announcement_body", with: "# Hello!")
    |> click_create_announcement

    assert has_announcement_title?(session, "Hello World")
    assert has_announcement_body?(session, "Hello")
    assert has_announcement_interest?(session, "everyone")
  end

  defp click_create_announcement(session) do
    session
    |> find("input[type=submit]")
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
end
