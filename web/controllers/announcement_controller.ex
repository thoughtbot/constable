defmodule Constable.AnnouncementController do
  use Constable.Web, :controller

  plug :scrub_params, "announcement" when action == :create

  alias Constable.{Announcement, Comment, Interest, Subscription}
  alias Constable.Services.AnnouncementCreator

  def index(conn, %{"all" => "true"}) do
    conn
    |> assign(:announcements, all_announcements)
    |> assign(:current_user, preload_interests(conn.assigns.current_user))
    |> render("index.html")
  end
  def index(conn, _params) do
    conn
    |> assign(:announcements, my_announcements(conn))
    |> assign(:current_user, preload_interests(conn.assigns.current_user))
    |> render("index.html")
  end

  def show(conn, %{"id" => id}) do
    announcement = Repo.get!(Announcement.with_announcement_list_assocs, id)
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

  def new(conn, _params) do
    changeset = Announcement.changeset(%Announcement{}, :create)
    interests = Repo.all(Interest)
    render(conn, "new.html", changeset: changeset, interests: interests)
  end

  def create(conn, %{"announcement" => announcement_params}) do
    interest_names = Map.get(announcement_params, "interests")
    announcement_params = announcement_params
      |> Map.delete("interests")
      |> Map.put("user_id", conn.assigns.current_user.id)

    case AnnouncementCreator.create(announcement_params, interest_names) do
      {:ok, announcement} ->
        redirect(conn, to: announcement_path(conn, :show, announcement.id))
      {:error, changeset} ->
        interests = Repo.all(Interest)
        render(conn, "new.html", changeset: changeset, interests: interests)
    end
  end

  defp my_announcements(conn) do
    conn.assigns.current_user
    |> Ecto.assoc(:interesting_announcements)
    |> Announcement.with_announcement_list_assocs
    |> Announcement.last_discussed_first
    |> Repo.all
  end

  defp all_announcements do
    Announcement.with_announcement_list_assocs
    |> Announcement.last_discussed_first
    |> Repo.all
  end

  defp preload_interests(user) do
    Repo.preload user, :interests
  end
end
