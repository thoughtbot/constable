defmodule Constable.ViewCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      use Constable.Web, :view

      import Constable.Factories
      alias Constable.UserView
      alias Constable.InterestsView
      alias Constable.SubscriptionView
      alias Constable.UserInterestView
      alias Constable.CommentView

      def ids_from(enumerable) do
        Enum.map(enumerable, fn(object) ->
          Map.get(object, :id)
        end)
      end
    end
  end

  setup tags do
    unless tags[:async] do
      Ecto.Adapters.SQL.restart_test_transaction(Constable.Repo, [])
    end

    :ok
  end
end
