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

  def find_by_id_and_user(id, user_id) do
    from a in Announcement, where: a.id == ^id and a.user_id == ^user_id
  end
end
