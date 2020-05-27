defmodule Constable.Services.HubProfileProviderTest do
  use Constable.TestWithEcto, async: true

  import Mock
  alias Constable.Services.HubProfileProvider

  describe "#fetch_profile_url" do
    test "returns the hub profile url for a user" do
      email = "test@example.com"
      user = insert(:user, email: email)

      mock_slug = "mollusk"

      mock_query = mock_slug_query_string(email)

      query_mock = fn query ->
        case query do
          ^mock_query ->
            mock_slug_query_result(mock_slug)

          _ ->
            nil
        end
      end

      profile_url =
        Mock.with_mock Neuron, query: query_mock do
          HubProfileProvider.fetch_profile_url(user)
        end

      assert profile_url == "#{Application.fetch_env!(:constable, :hub_url)}/people/#{mock_slug}"
    end
  end

  describe "#fetch_image_url" do
    test "returns the hub profile image url for a user" do
      email = "test@example.com"
      user = insert(:user, email: email)

      mock_image_url = "http://example.com/test.png"

      mock_query = mock_image_url_query_string(email)

      query_mock = fn query ->
        case query do
          ^mock_query ->
            mock_image_url_query_result(mock_image_url)

          _ ->
            nil
        end
      end

      image_url =
        Mock.with_mock Neuron, query: query_mock do
          HubProfileProvider.fetch_image_url(user)
        end

      assert image_url == mock_image_url
    end
  end

  defp mock_slug_query_string(email) do
    """
      {
        person(email: "#{email}") {
          slug
        }
      }
    """
  end

  defp mock_slug_query_result(mock_slug) do
    {:ok,
     %Neuron.Response{
       body: %{
         "data" => %{
           "person" => %{
             "slug" => mock_slug
           }
         }
       }
     }}
  end

  defp mock_image_url_query_string(email) do
    """
      {
        person(email: "#{email}") {
          image_url
        }
      }
    """
  end

  defp mock_image_url_query_result(mock_image_url) do
    {:ok,
     %Neuron.Response{
       body: %{
         "data" => %{
           "person" => %{
             "image_url" => mock_image_url
           }
         }
       }
     }}
  end
end
