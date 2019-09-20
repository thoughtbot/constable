defmodule FakeProfileProvider do
  alias Constable.Services.ProfileProvider
  @behaviour ProfileProvider

  @impl ProfileProvider
  def profile_url(_user) do
    "http://example.com/"
  end

  @impl ProfileProvider
  def image_url(_user) do
    "/images/ralph.png"
  end
end
