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
      %OAuth2.Response{
        body: %{
          "email" => @oauth_email_address,
          "name" => "Gumbo McGee"
        }
      }
    end
  end

  defmodule NonThoughtbotRequestWithAccessToken do
    @oauth_email_address "fake@example.com"

    def get!(_token, _path) do
      %OAuth2.Response{
        body: %{
          "email" => @oauth_email_address,
          "name" => "Gumbo McGee"
        }
      }
    end
  end

  defmodule FakeTokenInfoGoogleStrategy do
    @oauth_email_address "fake@thoughtbot.com"

    def get_tokeninfo!(_id_token) do
      %{"email" => @oauth_email_address, "name" => "John Doe"}
    end
  end

  defmodule NonThoughtbotTokenInfoGoogleStrategy do
    @oauth_email_address "fake@example.com"

    def get_tokeninfo!(_id_token) do
      %{"email" => @oauth_email_address, "name" => "John Doe"}
    end
  end

  test "index redirects to google with the correct redirect URI" do
    conn = get(conn, "/auth", redirect_uri: "foo.com")

    auth_uri = google_auth_uri(
      client_id: Constable.Env.get("CLIENT_ID"),
      redirect_uri: auth_url(conn, :javascript_callback),
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
      |> get("/auth/javascript_callback", code: "foo")

    user_auth_token = Repo.one(User).token
    assert redirected_to(conn) =~ "foo.com/#{user_auth_token}?new_user=true"
    assert user_has_interest(everyone_interest)
  end

  test "callback redirects to success URI with existing user token" do
    Pact.override(self, "token_retriever", FakeTokenRetriever)
    Pact.override(self, "request_with_access_token", FakeRequestWithAccessToken)
    create(:user, email: @oauth_email_address)

    conn =
      request_authorization("foo.com")
      |> get("/auth/javascript_callback", code: "foo")

    user_auth_token = Repo.one(User).token
    assert redirected_to(conn) =~ "foo.com/#{user_auth_token}?new_user=false"
  end

  test "callback redirects to the root path when there is an error" do
    conn = get(conn, "/auth/javascript_callback", error: "Foo")

    assert redirected_to(conn) =~  "/"
  end

  test "callback redirects to the root path when the email is non-thoughtbot" do
    create_everyone_interest
    Pact.override(self, "token_retriever", FakeTokenRetriever)
    Pact.override(self, "request_with_access_token", NonThoughtbotRequestWithAccessToken)

    conn =
      request_authorization("foo.com")
      |> get("/auth/javascript_callback", code: "foo")

    assert redirected_to(conn) =~  "/"
    refute Repo.one(User)
  end

  test "mobile_callback returns user json when successful" do
    create_everyone_interest
    auth_params = %{"idToken" => "token"}
    Pact.override(self, :google_strategy, FakeTokenInfoGoogleStrategy)

    conn = post conn, auth_path(conn, :mobile_callback), auth_params

    user_auth_token = Repo.one(User).token
    assert json_response(conn, 201)
    assert json_response(conn, 201)["user"]["token"] == user_auth_token
  end

  test "mobile_callback returns error json when user has non-thoughtbot email" do
    create_everyone_interest
    auth_params = %{"idToken" => "token"}
    Pact.override(self, :google_strategy, NonThoughtbotTokenInfoGoogleStrategy)

    conn = post conn, auth_path(conn, :mobile_callback), auth_params

    assert json_response(conn, 403)
    assert json_response(conn, 403)["error"] == "Non-thoughtbot email"
  end

  test "browser_callback sets user_id on session when successful" do
    create_everyone_interest
    Pact.override(self, "token_retriever", FakeTokenRetriever)
    Pact.override(self, "request_with_access_token", FakeRequestWithAccessToken)


    conn =
      request_authorization("foo.com")
      |> get("/auth/browser_callback", code: "foo")

    user = Repo.one(User)
    assert get_session(conn, :user_id) == user.id
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
