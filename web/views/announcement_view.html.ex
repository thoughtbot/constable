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
