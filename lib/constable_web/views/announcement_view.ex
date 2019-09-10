defmodule ConstableWeb.AnnouncementView do
  use ConstableWeb, :view

  def json_interests(interests) do
    interests
    |> Enum.map(&%{name: &1.name})
    |> Poison.encode!()
  end

  def comma_separated_interest_names(interests) when is_list(interests) do
    interests
    |> Enum.map(& &1.name)
    |> Enum.join(",")
  end

  def comma_separated_interest_names(_), do: ""

  def class_for("all", %{params: %{"all" => "true"}}), do: "selected"

  def class_for("your announcements", conn = %{params: %{"user_id" => id}}) do
    if current_user_same_as_announcements_user?(conn, id) do
      "selected"
    end
  end

  def class_for(
    "your comments",
    conn = %{params: %{"user_id" => id, "comments" => "true"}}
  ) do
    if current_user_same_as_announcements_user?(conn, id) do
      "selected"
    end
  end

  def class_for("your interests", %{params: %{"all" => "true"}}), do: nil
  def class_for("your interests", %{params: %{"user_id" => _}}), do: nil
  def class_for("your interests", _), do: "selected"
  def class_for(_, _), do: nil

  defp current_user_same_as_announcements_user?(conn, announcements_user_id) do
    "#{conn.assigns[:current_user].id}" == announcements_user_id
  end

  def interest_count_for(user) do
    length(user.interests)
  end

  def user_autocomplete_json(users) do
    users
    |> Enum.map(&format_user_json/1)
    |> Poison.encode!()
  end

  defp format_user_json(user) do
    %{name: user.name, username: user.username, gravatar_url: gravatar(user)}
  end
end
