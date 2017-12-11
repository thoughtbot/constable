defmodule GoogleStrategy do
  use OAuth2.Strategy
  alias OAuth2.Request

  def client(redirect_uri) do
    OAuth2.Client.new([
      client_id: System.get_env("CLIENT_ID"),
      client_secret: System.get_env("CLIENT_SECRET"),
      authorize_url: "https://accounts.google.com/o/oauth2/auth",
      token_url: "https://www.googleapis.com/oauth2/v3/token",
      site: "https://www.googleapis.com",
      redirect_uri: Pact.get("oauth_redirect_strategy").redirect_uri(redirect_uri),
    ])
  end

  def authorize_url!(redirect_uri) do
    client(redirect_uri)
    |> put_param(:scope, "email")
    |> maybe_add_redirect_uri_state(redirect_uri)
    |> OAuth2.Client.authorize_url!([])
  end

  def get_token!(redirect_uri, params \\ [], headers \\ [], options \\ []) do
    OAuth2.Client.get_token!(client(redirect_uri), params, headers, options)
  end

  @doc """
  Makes a request to the tokeninfo endpoint
  that validates the given token is valid.

  Returns the response.body from the request
  or raises an error if received.

  The body contains the users's information:
  email, name, etc.

  More information available:
  https://developers.google.com/identity/sign-in/ios/backend-auth#calling-the-tokeninfo-endpoint

  ## Arguments

  * `id_token` - id_token received from Google
  """
  def get_tokeninfo!(redirect_uri, id_token) do
    {client, url} = tokeninfo_url(client(redirect_uri), id_token)
    case Request.post(url, client.params, client.headers) do
      {:ok, response} -> response.body
      {:error, error} -> raise error
    end
  end

  def tokeninfo_url(client, id_token) do
    client
    |> put_header("Content-Type", "application/x-www-form-urlencoded")
    |> put_param(:id_token, id_token)
    |> to_url("https://www.googleapis.com/oauth2/v3/tokeninfo")
  end

  # Strategy Callbacks

  def authorize_url(client, params) do
    OAuth2.Strategy.AuthCode.authorize_url(client, params)
  end

  def get_token(client, params, headers) do
    client
    |> put_header("Accept", "application/json")
    |> OAuth2.Strategy.AuthCode.get_token(params, headers)
  end

  defp to_url(client, endpoint) do
    url = endpoint <> "?" <> URI.encode_query(client.params)
    {client, url}
  end

  defp maybe_add_redirect_uri_state(client, original_redirect_uri) do
    state_param = Pact.get("oauth_redirect_strategy").state_param(original_redirect_uri)
    if state_param do
      put_param(client, :state, state_param)
    else
      client
    end
  end
end
