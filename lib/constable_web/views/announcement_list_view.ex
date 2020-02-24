defmodule ConstableWeb.AnnouncementListView do
  use ConstableWeb, :view

  def commenters(announcement) do
    comment_users = Enum.map(announcement.comments, & &1.user)

    Enum.uniq([announcement.user | comment_users])
  end
end
