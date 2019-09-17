defmodule ConstableWeb.UserControlsSettingsTest do
  use ConstableWeb.AcceptanceCase

  @modal_window css("[data-role=settings-modal]")
  @settings_link css("[data-role=settings-link]")
  @closing_icon css("[data-role=closing-icon]")

  test "user views their settings", %{session: session} do
    user = insert(:user)

    session
    |> visit(Routes.announcement_path(Endpoint, :new, as: user.id))
    |> open_settings_modal

    assert showing_modal?(session)
  end

  test "user closes the settings modal with icon", %{session: session} do
    user = insert(:user)

    session
    |> visit(Routes.announcement_path(Endpoint, :new, as: user.id))
    |> open_settings_modal
    |> assert_has(@modal_window)
    |> close_modal_with_icon

    refute showing_modal?(session)
  end

  test "user closes the settings modal with esc", %{session: session} do
    user = insert(:user)

    session
    |> visit(Routes.announcement_path(Endpoint, :new, as: user.id))
    |> open_settings_modal
    |> assert_has(@modal_window)
    |> close_modal_with_esc

    refute showing_modal?(session)
  end

  defp open_settings_modal(session) do
    session
    |> click(@settings_link)

    session
  end

  defp close_modal_with_icon(session) do
    session
    |> click(@closing_icon)

    session
  end

  defp close_modal_with_esc(session) do
    session
    |> send_keys([:escape])

    session
  end

  defp showing_modal?(session) do
    session |> has?(@modal_window)
  end
end
