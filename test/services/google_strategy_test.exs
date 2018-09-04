defmodule Constable.GoogleStrategyTest do
  use Constable.TestWithEcto, async: true

  test ".tokeninfo_url adds correct headers" do
    client = GoogleStrategy.client("/")

    {client, _} = GoogleStrategy.tokeninfo_url(client, "1234")

    {"content-type", content_type} = List.first(client.headers)
    assert content_type == "application/x-www-form-urlencoded"
  end

  test ".tokeninfo_url adds correct params" do
    client = GoogleStrategy.client("/")

    {client, _} = GoogleStrategy.tokeninfo_url(client, "1234")

    assert Map.get(client.params, "id_token") == "1234"
  end

  test ".tokeninfo_url adds id_token to the URL" do
    client = GoogleStrategy.client("/")

    {_, url} = GoogleStrategy.tokeninfo_url(client, "1234")

    assert String.ends_with?(url, "id_token=1234")
  end
end
