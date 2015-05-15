defmodule Constable.TestWithEcto do
  use ExUnit.CaseTemplate
  alias Ecto.Adapters.SQL
  alias Constable.Repo

  setup tags do
    unless tags[:async] do
      Ecto.Adapters.SQL.restart_test_transaction(Constable.Repo, [])
    end

    :ok
  end
end
