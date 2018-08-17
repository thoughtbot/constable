defmodule ConstableWeb.AcceptanceCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      use Wallaby.DSL

      alias ConstableWeb.Endpoint
      import Ecto.Schema
      import Ecto.Query, only: [from: 2]
      import ConstableWeb.Router.Helpers
      import Constable.Factory
      import ConstableWeb.WallabyHelper
      import Wallaby.Query, only: [link: 1, button: 1, css: 1, text_field: 1]

      Application.put_env(:wallaby, :base_url, ConstableWeb.Endpoint.url)
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Constable.Repo)
    metadata = Phoenix.Ecto.SQL.Sandbox.metadata_for(Constable.Repo, self())
    {:ok, session} = Wallaby.start_session(metadata: metadata)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Constable.Repo, {:shared, self()})
    end

    {:ok, session: session}
  end
end
