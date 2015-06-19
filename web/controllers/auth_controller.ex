defmodule Constable.AuthController do
  use Constable.Web, :controller
  import Ecto.Query
  require Logger

  alias OAuth2.Strategy.AuthCode
  alias Constable.Interest
  alias Constable.User
  alias Constable.UserInterest
  alias Constable.Repo
  alias Constable.Queries

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

    user = find_or_insert_user(token)
    if from_thoughtbot?(user) do
      conn |> redirect(external: redirect_after_success_uri(conn, user.token))
    else
      Logger.warn("Non-thoughtbot email")
      conn |> redirect external: "/"
    end
  end

  def callback(conn, %{"error" => error_message}) do
    Logger.warn("Auth error: #{error_message}")
    conn |> redirect external: "/"
  end

  defp get_userinfo(token) do
    Pact.get("request_with_access_token").get!(token, "/oauth2/v1/userinfo?alt=json")
  end

  defp from_thoughtbot?(user) do
    String.ends_with?(user.email, "@thoughtbot.com")
  end

  defp find_or_insert_user(token) do
    userinfo = get_userinfo(token)
    %{"email" => email, "name" => name} = userinfo
    unless user = Repo.one(Queries.User.with_email(email)) do
      user =
        %User{email: email, name: name}
        |> Repo.insert!
        |> add_everyone_interest
    end
    user
  end

  defp add_everyone_interest(user) do
    user_interest_params = %{user_id: user.id, interest_id: everyone_interest.id}
    UserInterest.changeset(%UserInterest{}, user_interest_params)
    |> Repo.insert!
    user
  end

  defp everyone_interest do
    Repo.get_by!(Interest, name: "everyone")
  end

  defp redirect_after_success_uri(conn, token) do
    "#{get_session(conn, :redirect_after_success_uri)}/#{token}"
  end

  defp authorize_url(conn) do
    AuthCode.authorize_url(strategy(conn), auth_params)
  end

  defp auth_params do
    %{redirect_uri: System.get_env("REDIRECT_URI"), scope: "openid email profile"}
  end

  defp token_params do
    Map.merge(%{headers: [{"Accept", "application/json"}]}, auth_params)
  end

  defp strategy(conn), do: conn.private.oauth2_strategy
end
