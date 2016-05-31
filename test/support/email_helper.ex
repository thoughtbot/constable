defmodule Constable.EmailHelper do
  alias Constable.Repo

  def merge_vars_for(user, announcement) do
    %{
      rcpt: user.email,
      vars: [
        %{
          name: "subscription_id",
          content: subscription_token_for(announcement, user)
        }
      ]
    }
  end

  defp subscription_token_for(announcement, user) do
    announcement
    |> Repo.preload(:subscriptions)
    |> Map.get(:subscriptions)
    |> Enum.find(fn(sub) -> sub.user_id == user.id end)
    |> Map.fetch!(:token)
  end
end
