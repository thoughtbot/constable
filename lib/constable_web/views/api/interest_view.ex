defmodule ConstableWeb.Api.InterestView do
  use Constable.Web, :view

  def render("index.json", %{interests: interests}) do
    %{interests: render_many(interests, ConstableWeb.Api.InterestView, "interest.json")}
  end

  def render("show.json", %{interest: interest}) do
    %{interest: render_one(interest, ConstableWeb.Api.InterestView, "interest.json")}
  end

  def render("interest.json", %{interest: interest}) do
    %{
      id: interest.id,
      name: interest.name,
      slack_channel: interest.slack_channel,
    }
  end
end
