defmodule Constable.Services.HubProfileProvider do
  alias ConstableWeb.Endpoint
  alias Constable.Services.ProfileProvider
  @behaviour ProfileProvider
  use Memoize

  @default_image_path "/images/ralph.png"

  @impl ProfileProvider
  defmemo profile_url(user) do
    "#{Application.fetch_env!(:constable, :hub_url)}/people/#{fetch_slug(user)}"
  end

  @impl ProfileProvider
  defmemo image_url(user) do
    case Neuron.query(person_image_url_by_email_query(user.email)) do
      {:ok, %Neuron.Response{body: %{"data" => %{"person" => %{"image_url" => image_url}}}}} ->
        image_url

      _ ->
        "#{Endpoint.url()}#{@default_image_path}"
    end
  end

  defp fetch_slug(user) do
    case Neuron.query(person_slug_by_email_query(user.email)) do
      {:ok, %Neuron.Response{body: %{"data" => %{"person" => %{"slug" => slug}}}}} ->
        slug

      _ ->
        nil
    end
  end

  defp person_slug_by_email_query(email) do
    """
      {
        person(email: "#{email}") {
          slug
        }
      }
    """
  end

  defp person_image_url_by_email_query(email) do
    """
      {
        person(email: "#{email}") {
          image_url
        }
      }
    """
  end
end
