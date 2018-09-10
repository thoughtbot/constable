defmodule ConstableWeb.AnnouncementListView do
  use Constable.Web, :view

  def user_gravatars(announcement) do
    author_gravatar = gravatar(announcement.user)
    comment_gravatars = commenter_gravatars(announcement)

    Enum.uniq([author_gravatar | comment_gravatars])
  end

  defp commenter_gravatars(%{comments: comments}) do
    Enum.map(comments, &comment_gravatar/1)
  end

  defp comment_gravatar(%{user: user}) do
    gravatar(user)
  end
end
