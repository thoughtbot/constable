defmodule Constable.AcceptanceCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      use Wallaby.DSL

      alias Constable.Endpoint
      import Ecto.Model
      import Ecto.Query, only: [from: 2]
      import Constable.Router.Helpers
      import Constable.Factory
      Application.put_env(:wallaby, :base_url, Constable.Endpoint.url)
    end
  end

  setup tags do
    unless tags[:async] do
      Ecto.Adapters.SQL.restart_test_transaction(Constable.Repo, [])
    end

    {:ok, session} = Wallaby.start_session
    session = Wallaby.Session.set_window_size(session, 900, 600)
    {:ok, session: session}
  end
end
