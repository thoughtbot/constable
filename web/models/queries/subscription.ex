defmodule Constable.Queries.Subscription do
  alias Constable.{Subscription, User}
  import Ecto.Query

  def for_announcement(announcement_id) do
    from s in Subscription,
      join: u in assoc(s, :user),
      where: u.active,
      where: s.announcement_id == ^announcement_id,
      preload: [:user]
  end
end
