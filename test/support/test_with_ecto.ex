defmodule Constable.TestWithEcto do
  use ExUnit.CaseTemplate
  alias Ecto.Adapters.SQL
  alias Constable.Repo

  setup do
    SQL.begin_test_transaction(Repo)

    on_exit fn ->
      SQL.rollback_test_transaction(Repo)
    end
  end
end
