defmodule FakeProfileProvider do
  alias ConstableWeb.Endpoint
  alias Constable.Services.ProfileProvider
  @behaviour ProfileProvider

  @impl ProfileProvider
  def profile_url(_user) do
    "http://example.com/"
  end

  @impl ProfileProvider
  def image_url(_user) do
    "#{Endpoint.url()}/images/ralph.png"
  end
end
