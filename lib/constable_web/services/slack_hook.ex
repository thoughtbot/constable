defmodule Constable.Services.SlackHook do
  import ConstableWeb.Router.Helpers

  alias Constable.Repo

  def new_announcement(announcement) do
    announcement = announcement |> Repo.preload([:interests, :user])

    Enum.each(announcement.interests, fn(interest) ->
      if interest.slack_channel do
        payload = %{
          text: "#{announcement.user.name} posted <#{announcement_url(ConstableWeb.Endpoint, :show, announcement)}|#{announcement.title}>",
          channel: interest.slack_channel,
        }

        post(payload)
      end
    end)
  end

  defp post(payload) do
    if slack_webhook_url() do
      spawn fn ->
        HTTPoison.post(slack_webhook_url(), Poison.encode!(payload))
      end
    end
  end

  defp slack_webhook_url do
    System.get_env("SLACK_WEBHOOK_URL")
  end
end
