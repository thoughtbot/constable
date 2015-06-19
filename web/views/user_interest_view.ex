defmodule Constable.UserInterestView do
  use Constable.Web, :view

  def render("show.json", %{user_interest: user_interest}) do
    %{
      id: user_interest.id,
      user_id: user_interest.user_id,
      interest_id: user_interest.interest_id
    }
  end
end
