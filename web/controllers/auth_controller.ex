defmodule Constable.AuthController do
  use Constable.Web, :controller
  require Logger

  alias Constable.Interest
  alias Constable.User
  alias Constable.UserInterest
  alias Constable.Repo
  alias Constable.Queries

  def index(conn, %{"browser" => "true"}) do
    conn
    |> redirect(external: GoogleStrategy.authorize_url!(auth_url(conn, :browser_callback)))
  end

  @doc """
  This action is reached via `/auth` and redirects to the Google Auth API.
  """
  def index(conn, %{"redirect_uri" => redirect_uri}) do
    conn
    |> put_session(:redirect_after_success_uri, redirect_uri)
    |> redirect(external: GoogleStrategy.authorize_url!(auth_url(conn, :javascript_callback)))
  end

  def browser_callback(conn, %{"code" => code}) do
    token = google_strategy.get_token!(auth_url(conn, :browser_callback), code: code)
    %{"email" => email, "name" => name} = get_userinfo(token)

    case find_or_insert_user(email, name) do
      nil -> 
        conn
        |> put_flash(:error, gettext("You must sign up with a thoughtbot email address"))
        |> redirect(external: "/")
      user ->
        conn
        |> put_session(:user_id, user.id)
        |> redirect(external: session_path(conn, :new))
    end
  end
  def browser_callback(conn, %{"error" => error_message}) do
    Logger.warn("Auth error: #{error_message}")
    conn
    |> put_flash(:error, error_message)
    |> redirect(external: "/")
  end

  @doc """
  This action is reached via `/auth/callback` is the the callback URL that
  the OAuth2 provider will redirect the user back to with a `code` that will
  be used to request an access token. The access token will then be used to
  access the email address on behalf of the user.
  """
  def javascript_callback(conn, %{"code" => code}) do
    token = google_strategy.get_token!(auth_url(conn, :javascript_callback), code: code)
    %{"email" => email, "name" => name} = get_userinfo(token)
    existing_user = find_user(email)

    case find_or_insert_user(email, name) do
      nil -> redirect(conn, external: "/")
      user -> redirect(conn, external: redirect_after_success_uri(conn, user.token, existing_user))
    end
  end
  def javascript_callback(conn, %{"error" => error_message}) do
    Logger.warn("Auth error: #{error_message}")
    conn |> redirect(external: "/")
  end

  @doc """
  This action is reached via `/auth/mobile_callback` is the the endpoint that
  mobile apps will pass in the token it received from Google.
  The token will then be used to access the email address on behalf of the user.
  """
  def mobile_callback(conn, %{"idToken" => id_token}) do
    %{"email" => email, "name" => name} = get_tokeninfo!(id_token)

    case find_or_insert_user(email, name) do
      nil -> conn |> put_status(403) |> json(%{error: "Non-thoughtbot email"})
      user -> conn |> put_status(201) |>  render("show.json", user: user)
    end
  end

  defp google_strategy do
    Pact.get(:google_strategy)
  end

  defp get_userinfo(token) do
    Pact.get("request_with_access_token").get!(token, "/oauth2/v1/userinfo?alt=json")
    |> Map.get(:body)
  end

  defp get_tokeninfo!(id_token) do
    google_strategy.get_tokeninfo!(id_token)
  end

  defp find_or_insert_user(email, name) do
    find_user(email) || insert_new_user(email, name)
  end

  defp find_user(email) do
    Repo.one(Queries.User.with_email(email))
  end

  defp insert_new_user(email, name) do
    changeset = User.create_changeset(%User{}, %{email: email, name: name})

    case Repo.insert(changeset) do
      {:ok, user} ->
        user |> add_everyone_interest
      {:error, _changeset} ->
        Logger.warn("Non-thoughtbot email")
        nil
    end
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

  defp redirect_after_success_uri(conn, token, existing_user) do
    "#{get_session(conn, :redirect_after_success_uri)}/#{token}?new_user=#{!existing_user}"
  end
end
