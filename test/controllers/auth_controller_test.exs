defmodule AuthControllerTest do
  use ConstableApi.TestWithEcto, async: false
  use RouterHelper
  alias ConstableApi.Router
  alias ConstableApi.User
  alias ConstableApi.Repo
  import Ecto.Query

  @google_authorize_url "https://accounts.google.com/o/oauth2/auth"

  defmodule FakeTokenRetriever do
    def get_token!(_conn, _code, _token_params) do
      "fake_auth_token"
    end
  end

  defmodule FakeRequestWithAccessToken do
    def get!(_token, _path) do
      %{"data" => %{"email" => "fake@example.com"}}
    end
  end

  test "index redirects to google with the correct redirect URI" do
    conn = call_router(Router, :get, "/auth")

    auth_uri = google_auth_uri(
      client_id: "",
      redirect_uri: "",
      response_type: "code",
      scope: "openid email"
    )
    assert_redirected(conn, auth_uri)
  end

  test "callback redirects to success URI with user auth token" do
    Pact.override(self, "token_retriever", FakeTokenRetriever)
    Pact.override(self, "request_with_access_token", FakeRequestWithAccessToken)

    conn = call_router(Router, :get, "/auth/callback", %{"code" => "1234"})

    user_auth_token = Repo.one(from u in User).token
    assert_redirected(conn, "/#{user_auth_token}")
  end

  test "callback redirects to the root path when there is an error" do
    conn = call_router(Router, :get, "/auth/callback", %{"error" => "Foo"})

    assert_redirected(conn, "/")
  end

  defp google_auth_uri(params) do
    query_params = URI.encode_query(params)
    "#{@google_authorize_url}?#{query_params}"
  end
end
