defmodule Constable.ViewCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      use Constable.Web, :view

      alias Constable.UserView
      alias Constable.InterestsView
      alias Constable.SubscriptionView
      alias Constable.UserInterestView
      alias Constable.CommentView
    end
  end
end
