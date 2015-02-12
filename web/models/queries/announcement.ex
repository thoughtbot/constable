defmodule ConstableApi.Queries.Announcement do
  alias ConstableApi.Announcement
  import Ecto.Query

  def with_sorted_comments do
    from a in Announcement,
      left_join: c in assoc(a, :comments),
      left_join: u in assoc(c, :user),
      order_by: [asc: c.inserted_at],
      preload: [:user, comments: {c, user: u}]
  end
end
