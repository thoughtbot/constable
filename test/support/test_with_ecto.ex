defmodule Constable.TestWithEcto do
  use ExUnit.CaseTemplate

  using do
    quote do
      import Constable.Factory
      alias Constable.Repo
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
