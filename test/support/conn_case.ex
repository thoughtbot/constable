defmodule Constable.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  imports other functionality to make it easier
  to build and query models.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """

  use ExUnit.CaseTemplate
  alias Constable.Repo

  using do
    quote do
      # Import conveniences for testing with connections
      use Phoenix.ConnTest

      # Alias the data repository and import query/model functions
      alias Constable.Repo
      import Ecto.Model
      import Ecto.Query, only: [from: 2]

      # Import URL helpers from the router
      import Constable.Router.Helpers

      # The default endpoint for testing
      @endpoint Constable.Endpoint

      def authenticate(user \\ nil) do
        unless user do
          user = Forge.saved_user(Repo)
        end

        conn = conn()
        |> put_req_header("accept", "application/json")
        |> put_req_header("authorization", user.token)
        %{conn: conn, user: user}
      end

      defp fetch_json_ids(key, conn, status \\ 200) do
        records = json_response(conn, status)[key]
        Enum.map(records, fn(json) ->
          Map.get(json, "id")
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
