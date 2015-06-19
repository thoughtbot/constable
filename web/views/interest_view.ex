defmodule Constable.InterestView do
  use Constable.Web, :view

  def render("show.json", %{interest: interest}) do
    %{
      id: interest.id,
      name: interest.name
    }
  end

  def render("name.json", %{interest: interest}), do: interest.name
end
