defmodule ConstableWeb.Api.UserInterestView do
  use Constable.Web, :view

  def render("index.json", %{user_interests: user_interests}) do
    %{user_interests: render_many(user_interests, ConstableWeb.Api.UserInterestView, "user_interest.json")}
  end

  def render("show.json", %{user_interest: user_interest}) do
    %{user_interest: render_one(user_interest, ConstableWeb.Api.UserInterestView, "user_interest.json")}
  end

  def render("user_interest.json", %{user_interest: user_interest}) do
    %{
      id: user_interest.id,
      user_id: user_interest.user_id,
      interest_id: user_interest.interest_id
    }
  end
end
