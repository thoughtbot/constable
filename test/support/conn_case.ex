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
      use Constable.Web, :view

      # Alias the data repository and import query/model functions
      alias Constable.Repo
      import Ecto.Model, except: [build: 2]
      import Ecto.Query, only: [from: 2]
      import Constable.Factories

      # Import URL helpers from the router
      import Constable.Router.Helpers

      # The default endpoint for testing
      @endpoint Constable.Endpoint

      def authenticate(user \\ create(:user)) do
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

      defmacro render_json(template, assigns) do
        view = Module.get_attribute(__CALLER__.module, :view)
        quote do
          render_json(unquote(template), unquote(view), unquote(assigns))
        end
      end
      def render_json(template, view, assigns) do
        view.render(template, assigns) |> format_json
      end

      defp format_json(data) do
        data |> Poison.encode! |> Poison.decode!
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
