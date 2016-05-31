defmodule Constable.TestWithEcto do
  use ExUnit.CaseTemplate

  using do
    quote do
      import Constable.Factory
      alias Constable.Repo

      defp merge_vars_for(user, announcement) do
        %{
          rcpt: user.email,
          vars: [
            %{
              name: "subscription_id",
              content: subscription_for(announcement, user).token
            }
          ]
        }
      end

      defp subscription_for(announcement, user) do
        announcement
        |> Repo.preload(:subscriptions)
        |> Map.get(:subscriptions)
        |> Enum.find(fn(sub) -> sub.user_id == user.id end)
      end
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Constable.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Constable.Repo, {:shared, self()})
    end

    :ok
  end
end
