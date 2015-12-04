defmodule GoogleStrategy do
  use OAuth2.Strategy
  alias OAuth2.Request

  def new do
    OAuth2.Client.new([
      client_id: System.get_env("CLIENT_ID"),
      client_secret: System.get_env("CLIENT_SECRET"),
      authorize_url: "https://accounts.google.com/o/oauth2/auth",
      token_url: "https://www.googleapis.com/oauth2/v3/token",
      site: "https://www.googleapis.com",
      redirect_uri: System.get_env("REDIRECT_URI"),
    ])
  end

  def authorize_url!(params \\ []) do
    new()
    |> put_param(:scope, "email")
    |> OAuth2.Client.authorize_url!(params)
  end

  def get_token!(params \\ [], headers \\ [], options \\ []) do
    OAuth2.Client.get_token!(new(), params, headers, options)
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
  def get_tokeninfo!(id_token) do
    {client, url} = tokeninfo_url(new(), id_token)
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
end
