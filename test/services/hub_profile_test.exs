defmodule Constable.Services.HubProfileTest do
  use Constable.TestWithEcto, async: true

  import Mock
  alias Constable.Services.HubProfile

  describe "#profile_url" do
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
          HubProfile.profile_url(user)
        end

      assert profile_url == "#{Application.fetch_env!(:constable, :hub_url)}/people/#{mock_slug}"
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
end
