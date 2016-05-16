defmodule Constable.EmailView do
  use Constable.Web, :view

  def red do
    "#c32f34"
  end

  def light_gray do
    "#aeaeae"
  end

  def unsubscribe_link do
    URI.decode unsubscribe_url(Constable.Endpoint, :show, subscription_id_merge_variable)
  end

  def notification_settings_link do
    settings_url(Constable.Endpoint, :show)
  end

  def author_avatar_url(user) do
    Exgravatar.generate(user.email)
  end

  def interest_links(announcement) do
    announcement
    |> Map.get(:interests)
    |> Enum.map(&make_link/1)
    |> Enum.join(", ")
  end

  def interest_names(announcement) do
    announcement
    |> Map.get(:interests)
    |> Enum.map(&("##{&1.name}"))
    |> Enum.join(", ")
  end

  defp make_link(interest) do
    "##{interest.name}"
    |> link(to: interest_url(Constable.Endpoint, :show, interest), style: "color: #{light_gray};")
    |> safe_to_string
  end

  defp subscription_id_merge_variable do
    "{{subscription_id}}"
  end
end
