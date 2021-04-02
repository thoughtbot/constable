defmodule ConstableWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common data structures and query the data layer.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      import Plug.Conn
      import Phoenix.ConnTest
      alias ConstableWeb.Router.Helpers, as: Routes

      import ConstableWeb.ConnCaseHelper

      # Alias the data repository and import query/model functions
      alias Constable.Repo
      import Ecto.Query, only: [from: 2]
      import Constable.Factory

      # The default endpoint for testing
      @endpoint ConstableWeb.Endpoint
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Constable.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Constable.Repo, {:shared, self()})
    end

    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end
end
