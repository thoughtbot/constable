defmodule Constable.Hub do
  @hub_people_endpoint "https://hub.thoughtbot.com/api/people"

  def active_people_emails do
    fetch_active_people |> Enum.map(&(&1["email"]))
  end

  def fetch_active_people do
    {:ok, response} = HTTPoison.get(
      @hub_people_endpoint,
      headers
    )

    response.body |> Poison.decode! |> Map.get("people")
  end

  defp headers do
    token = System.get_env("HUB_API_TOKEN")
    %{
      "Content-Type" => "application/json",
      "Accept" => "application/vnd.hub+json; version=1",
      "AUTHORIZATION" => "Token token=#{token}"
    }
  end
end
