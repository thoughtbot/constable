defmodule ConstableWeb.UserControlsSettingsTest do
  use ConstableWeb.AcceptanceCase

  test "user views their settings", %{session: session} do
    user = insert(:user)

    session
    |> visit(Routes.settings_path(Endpoint, :show, as: user.id))
    |> has_text?("Profile and Settings")
  end
end
