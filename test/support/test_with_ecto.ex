defmodule Constable.TestWithEcto do
  use ExUnit.CaseTemplate

  using do
    quote do
      import Constable.Factories
      alias Constable.Repo
    end
  end

  setup tags do
    unless tags[:async] do
      Ecto.Adapters.SQL.restart_test_transaction(Constable.Repo, [])
    end

    :ok
  end
end
