defmodule OAuthRedirectStrategy do
  def redirect_uri(original_redirect_uri) do
    oauth_redirect_override() || original_redirect_uri
  end

  def state_param(original_redirect_uri) do
    if oauth_redirect_override() do
      original_redirect_uri
    else
      nil
    end
  end

  defp oauth_redirect_override do
    System.get_env("OAUTH_REDIRECT_OVERRIDE")
  end
end
