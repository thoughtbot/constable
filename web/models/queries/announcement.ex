defmodule ConstableApi.Queries.Announcement do
  alias ConstableApi.Announcement
  import Ecto.Query

  def with_sorted_comments do
    from a in Announcement,
      left_join: c in assoc(a, :comments),
      order_by: [asc: c.inserted_at],
      preload: [comments: c]
  end
end
