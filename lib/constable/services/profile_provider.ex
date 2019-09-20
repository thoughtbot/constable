defmodule Constable.Services.ProfileProvider do
  alias Constable.User

  @callback profile_url(User.t()) :: String.t()
  @callback image_url(User.t()) :: String.t()
end
