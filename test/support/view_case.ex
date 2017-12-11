defmodule ConstableWeb.ViewCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      use Constable.Web, :view

      import Constable.Factory
      alias ConstableWeb.UserView
      alias ConstableWeb.InterestsView
      alias ConstableWeb.SubscriptionView
      alias ConstableWeb.UserInterestView
      alias ConstableWeb.CommentView
      import ConstableWeb.ViewCaseHelper
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
