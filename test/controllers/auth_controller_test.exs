defmodule AuthControllerTest do
  use Constable.ConnCase
  alias Constable.User
  alias Constable.UserInterest

  @google_authorize_url "https://accounts.google.com/o/oauth2/auth"
  @oauth_email_address "fake@thoughtbot.com"

  defmodule FakeTokenRetriever do
    def get_token!(_conn, _code, _token_params) do
      "fake_auth_token"
    end
  end

  defmodule FakeRequestWithAccessToken do
    @oauth_email_address "fake@thoughtbot.com"

    def get!(_token, _path) do
      %{
        "email" => @oauth_email_address,
        "name" => "Gumbo McGee"
      }
    end
  end

  defmodule NonThoughtbotRequestWithAccessToken do
    @oauth_email_address "fake@example.com"

    def get!(_token, _path) do
      %{
        "email" => @oauth_email_address,
        "name" => "Gumbo McGee"
      }
    end
  end

  test "index redirects to google with the correct redirect URI" do
    conn = get(conn, "/auth", redirect_uri: "foo.com")

    auth_uri = google_auth_uri(
      client_id: "",
      redirect_uri: "",
      response_type: "code",
      scope: "email"
    )
    assert redirected_to(conn) =~ auth_uri
    assert get_session(conn, :redirect_after_success_uri) == "foo.com"
  end

  test "callback redirects to success URI with newly created user token" do
    everyone_interest = create_everyone_interest
    Pact.override(self, "token_retriever", FakeTokenRetriever)
    Pact.override(self, "request_with_access_token", FakeRequestWithAccessToken)

    conn =
      request_authorization("foo.com")
      |> get("/auth/callback", code: "foo")

    user_auth_token = Repo.one(User).token
    assert redirected_to(conn) =~ "foo.com/#{user_auth_token}"
    assert user_has_interest(everyone_interest)
  end

  test "callback redirects to success URI with existing user token" do
    Pact.override(self, "token_retriever", FakeTokenRetriever)
    Pact.override(self, "request_with_access_token", FakeRequestWithAccessToken)
    create(:user, email: @oauth_email_address)

    conn =
      request_authorization("foo.com")
      |> get("/auth/callback", code: "foo")

    user_auth_token = Repo.one(User).token
    assert redirected_to(conn) =~ "foo.com/#{user_auth_token}"
  end

  test "callback redirects to the root path when there is an error" do
    conn = get(conn, "/auth/callback", error: "Foo")

    assert redirected_to(conn) =~  "/"
  end

  test "callback redirects to the root path when the email is non-thoughtbot" do
    create_everyone_interest
    Pact.override(self, "token_retriever", FakeTokenRetriever)
    Pact.override(self, "request_with_access_token", NonThoughtbotRequestWithAccessToken)

    conn =
      request_authorization("foo.com")
      |> get("/auth/callback", code: "foo")

    assert redirected_to(conn) =~  "/"
    refute Repo.one(User)
  end

  defp create_everyone_interest do
    create(:interest, name: "everyone")
  end

  defp request_authorization(redirect_uri) do
    get(conn, "/auth", redirect_uri: redirect_uri)
  end

  defp google_auth_uri(params) do
    query_params = URI.encode_query(params)
    "#{@google_authorize_url}?#{query_params}"
  end

  defp user_has_interest(interest) do
    user = Repo.one(User)
    Repo.get_by!(UserInterest,
      user_id: user.id,
      interest_id: interest.id
    )
  end
end
