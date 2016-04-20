defmodule Constable.AnnouncementView do
  use Constable.Web, :view

  def class_for("all", %{params: %{"all" => "true"}}) do
    "selected"
  end
  def class_for("mine", %{params: %{"all" => "true"}}), do: nil
  def class_for("mine", _) do
    "mine selected"
  end
  def class_for(_, _), do: nil
end
