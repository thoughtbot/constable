defmodule Constable.Api.InterestView do
  use Constable.Web, :view

  def render("index.json", %{interests: interests}) do
    %{data: render_many(interests, Constable.Api.InterestView, "interest.json")}
  end

  def render("show.json", %{interest: interest}) do
    %{data: render_one(interest, Constable.Api.InterestView, "interest.json")}
  end

  def render("interest.json", %{interest: interest}) do
    %{
      id: interest.id,
      name: interest.name,
    }
  end
end
