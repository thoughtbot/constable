defmodule ConstableApi.AuthController do
  use Phoenix.Controller
  import Ecto.Query
  require Logger

  alias OAuth2.Strategy.AuthCode
  alias ConstableApi.User
  alias ConstableApi.Repo

  plug :action

  @doc """
  This action is reached via `/auth` and redirects to the Google Auth API.
  """
  def index(conn, %{"redirect_uri" => redirect_uri}) do
    conn
    |> put_session(:redirect_after_success_uri, redirect_uri)
    |> redirect external: authorize_url(conn)
  end

  @doc """
  This action is reached via `/auth/callback` is the the callback URL that
  the OAuth2 provider will redirect the user back to with a `code` that will
  be used to request an access token. The access token will then be used to
  access the email address on behalf of the user.
  """
  def callback(conn, %{"code" => code}) do
    token = Pact.get("token_retriever").get_token!(strategy(conn), code, token_params)
    user = get_email_address(token) |> find_or_insert_user
    conn |> redirect(external: redirect_after_success_uri(conn, user.token))
  end

  def callback(conn, %{"error" => error_message}) do
    Logger.warn("Auth error: #{error_message}")
    conn |> redirect external: "/"
  end

  defp get_email_address(token) do
    Pact.get("request_with_access_token").get!(token, "/userinfo/email?alt=json")
    |> get_in(["data", "email"])
  end

  defp find_or_insert_user(email) do
    unless user = Repo.one(from u in User, where: u.email == ^email) do
      user = %User{email: email} |> Repo.insert
    end
    user
  end

  defp redirect_after_success_uri(conn, token) do
    "#{get_session(conn, :redirect_after_success_uri)}/#{token}"
  end

  defp authorize_url(conn) do
    AuthCode.authorize_url(strategy(conn), auth_params)
  end

  defp auth_params do
    %{redirect_uri: System.get_env("REDIRECT_URI"), scope: "openid email"}
  end

  defp token_params do
    Map.merge(%{headers: [{"Accept", "application/json"}]}, auth_params)
  end

  defp strategy(conn), do: conn.private.oauth2_strategy
end
