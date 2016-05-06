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

  using do
    quote do
      # Import conveniences for testing with connections
      use Phoenix.ConnTest
      use Constable.Web, :view
      import Constable.ConnTestHelper

      # Alias the data repository and import query/model functions
      alias Constable.Repo
      import Ecto.Query, only: [from: 2]
      import Constable.Factory

      # Import URL helpers from the router
      import Constable.Router.Helpers

      # The default endpoint for testing
      @endpoint Constable.Endpoint

      def with_session(conn, session_params \\ []) do
        session_opts =
          Plug.Session.init(
            store: :cookie,
            key: "_app",
            encryption_salt: "abc",
            signing_salt: "abc"
          )

        conn
        |> Map.put(:secret_key_base, String.duplicate("abcdefgh", 8))
        |> Plug.Session.call(session_opts)
        |> Plug.Conn.fetch_session
        |> Plug.Conn.fetch_query_params
        |> put_session_params_in_session(session_params)
      end

      defp put_session_params_in_session(conn, session_params) do
        List.foldl(session_params, conn, fn ({key, value}, acc)
          -> Plug.Conn.put_session(acc, key, value) end)
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
