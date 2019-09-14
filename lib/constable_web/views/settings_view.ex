defmodule ConstableWeb.SettingsView do
  use ConstableWeb, :view
  alias Constable.Services.HubProfile

  def hub_profile_url(user) do
    HubProfile.profile_url(user)
  end
end
