defmodule ConstableWeb.EmailView do
  use ConstableWeb, :view

  def red do
    "#c32f34"
  end

  def light_gray do
    "#aeaeae"
  end

  def unsubscribe_link do
    URI.decode(
      Routes.unsubscribe_url(ConstableWeb.Endpoint, :show, subscription_id_merge_variable())
    )
  end

  def notification_settings_link do
    Routes.settings_url(ConstableWeb.Endpoint, :show)
  end

  def author_avatar_url(user) do
    gravatar_url(user.email)
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
    |> Enum.map(&"##{&1.name}")
    |> Enum.join(", ")
  end

  def unique_commenters(comments) do
    Enum.map(comments, fn c -> c.user end)
    |> Enum.uniq()
  end

  def unique_commenters(announcement, comments) do
    Enum.filter(comments, fn c -> c.announcement_id == announcement.id end)
    |> Enum.map(fn c -> c.user end)
    |> Enum.uniq()
  end

  def commenter_names(users) do
    users
    |> Enum.map(fn user -> user.name end)
  end

  def discussed_announcements(comments) do
    Enum.map(comments, fn c -> c.announcement end)
    |> Enum.uniq()
  end

  def announcement_url_for_footer(announcement, nil) do
    Routes.announcement_url(ConstableWeb.Endpoint, :show, announcement)
  end

  def announcement_url_for_footer(announcement, comment) do
    announcement_url_for_footer(announcement, nil) <> "#comment-#{comment.id}"
  end

  def new_comments(comments, announcement) do
    Enum.filter(comments, fn c -> c.announcement_id == announcement.id end)
  end

  defp make_link(interest) do
    "##{interest.name}"
    |> link(
      to: Routes.interest_url(ConstableWeb.Endpoint, :show, interest),
      style: "color: #{light_gray()};"
    )
    |> safe_to_string
  end

  defp subscription_id_merge_variable do
    "{{subscription_id}}"
  end
end
