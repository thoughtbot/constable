defmodule Constable.AnnouncementView do
  use Constable.Web, :view

  def json_interests(interests) do
    interests
    |> Enum.map(&(%{name: &1.name}))
    |> Poison.encode!
  end

  def class_for("all", %{params: %{"all" => "true"}}) do
    "selected"
  end
  def class_for("mine", %{params: %{"all" => "true"}}), do: nil
  def class_for("mine", _) do
    "mine selected"
  end
  def class_for(_, _), do: nil
end
