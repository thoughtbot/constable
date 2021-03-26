defmodule ConstableWeb.UserUnsubscribesTest do
  use ConstableWeb.AcceptanceCase

  test "shows unsubscribe message when logged in", %{session: session} do
    announcement = insert(:announcement)
    subscription = insert(:subscription, announcement: announcement)
    user = insert(:user)

    session
    |> visit(Routes.unsubscribe_path(Endpoint, :show, subscription.token, as: user))

    assert has_unsubscribed_flash_message?(session)
    assert has_announcement_title?(session, announcement.title)
  end

  test "shows unsubscribed message when logged out", %{session: session} do
    subscription = insert(:subscription)

    session
    |> visit(Routes.unsubscribe_path(Endpoint, :show, subscription.token))

    assert has_unsubscribed_flash_message?(session)
    assert has_login_button?(session)
  end

  defp has_unsubscribed_flash_message?(session) do
    session
    |> find(css(".flash"))
    |> has_text?("unsubscribed")
  end

  defp has_announcement_title?(session, text) do
    session
    |> find(css("h1[data-role=title]"))
    |> has_text?(text)
  end

  defp has_login_button?(session) do
    session
    |> find(css("a.sign-in-link"))
    |> has_text?("Sign in")
  end
end
