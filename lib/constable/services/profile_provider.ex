defmodule Constable.Services.ProfileProvider do
  alias Constable.User

  @callback fetch_profile_url(User.t()) :: String.t()
  @callback fetch_image_url(User.t()) :: String.t()
end
