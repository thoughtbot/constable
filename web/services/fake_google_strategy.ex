defmodule FakeGoogleStrategy do
  def get_token!(_redirect_uri, _params), do: "fake_token"
end
