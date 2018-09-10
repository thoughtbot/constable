defmodule Constable.Pact do
  use Pact

  register :daily_digest, Constable.DailyDigest
  register :google_strategy, GoogleStrategy
  register :oauth_redirect_strategy, OAuthRedirectStrategy
  register :request_with_access_token, OAuth2.Client
  register :token_retriever, OAuth2.Strategy.AuthCode
end
