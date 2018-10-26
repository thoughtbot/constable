defmodule ConstableWeb.AnnouncementView do
  use ConstableWeb, :view

  def json_interests(interests) do
    interests
    |> Enum.map(&(%{name: &1.name}))
    |> Poison.encode!
  end

  def comma_separated_interest_names(interests) when is_list(interests) do
    interests
    |> Enum.map(&(&1.name))
    |> Enum.join(",")
  end

  def comma_separated_interest_names(_), do: ""

  def class_for("all", %{params: %{"all" => "true"}}) do
    "selected"
  end
  def class_for("mine", %{params: %{"all" => "true"}}), do: nil
  def class_for("mine", _) do
    "mine selected"
  end
  def class_for(_, _), do: nil

  def interest_count_for(user) do
    length user.interests
  end
end
