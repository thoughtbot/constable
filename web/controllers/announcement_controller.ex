defmodule Constable.AnnouncementController do
  use Constable.Web, :controller

  alias Constable.{Announcement, Comment, Subscription}

  def index(conn, %{"all" => "true"}) do
    render(conn, "index.html", announcements: all_announcements)
  end
  def index(conn, _params) do
    render(conn, "index.html", announcements: my_announcements(conn))
  end

  def show(conn, %{"id" => id}) do
    announcement = Repo.get!(Announcement, id) |> preload_associations
    comment = Comment.changeset(:create, %{})
    subscription = Repo.get_by(Subscription,
      announcement_id: announcement.id,
      user_id: conn.assigns.current_user.id
    )

    conn
    |> render("show.html",
      announcement: announcement,
      comment: comment,
      subscription: subscription
    )
  end

  defp my_announcements(conn) do
    conn.assigns.current_user
    |> Repo.preload(:interesting_announcements)
    |> Map.get(:interesting_announcements)
    |> preload_associations
    |> sort_announcements
  end

  defp all_announcements do
    Announcement
    |> Repo.all
    |> preload_associations
    |> sort_announcements
  end

  defp sort_announcements(announcements) do
    Enum.sort(announcements, &compare_announcements/2)
  end

  defp compare_announcements(first, second) do
    first = Enum.max([first.updated_at, List.last(first.comments)])
    second = Enum.max([second.updated_at, List.last(second.comments)])
    first > second
  end

  defp preload_associations(announcements) do
    Repo.preload(announcements, [
      :interests,
      :user,
      comments: from(c in Comment, order_by: [asc: c.inserted_at]),
      comments: :user
    ])
  end
end
