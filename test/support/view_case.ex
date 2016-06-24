defmodule Constable.ViewCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      use Constable.Web, :view

      import Constable.Factory
      alias Constable.UserView
      alias Constable.InterestsView
      alias Constable.SubscriptionView
      alias Constable.UserInterestView
      alias Constable.CommentView
      import Constable.ViewCaseHelper
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
