defmodule ConstableWeb.AnnouncementController do
  use ConstableWeb, :controller

  alias Constable.User
  alias Constable.Services.AnnouncementUpdater

  alias Constable.{Announcement, Comment, Interest, Subscription}
  alias Constable.Services.AnnouncementCreator

  plug(Constable.Plugs.Deslugifier, slugified_key: "id")

  def index(conn, %{"all" => "true"} = params) do
    index_page = all_announcements() |> Repo.paginate(params)

    conn
    |> assign(:announcements, index_page.entries)
    |> assign(:show_all, true)
    |> assign(:current_user, preload_interests(conn.assigns.current_user))
    |> assign(:index_page, index_page)
    |> page_title("Announcements")
    |> render("index.html")
  end

  def index(conn, %{"interest" => interest, "page" => page}) do
    conn
    |> redirect(to: Routes.interest_path(conn, :show, interest, page: page))
  end

  def index(conn, params) do
    index_page = my_announcements(conn) |> Repo.paginate(params)

    conn
    |> assign(:announcements, index_page.entries)
    |> assign(:show_all, false)
    |> assign(:current_user, preload_interests(conn.assigns.current_user))
    |> assign(:index_page, index_page)
    |> page_title("Announcements")
    |> render("index.html")
  end

  def show(conn, %{"id" => id}) do
    announcement = Repo.get!(Announcement.with_announcement_list_assocs(), id)
    comment = Comment.create_changeset(%{})

    subscription =
      Repo.get_by(Subscription,
        announcement_id: announcement.id,
        user_id: conn.assigns.current_user.id
      )

    conn
    |> render("show.html",
      announcement: announcement,
      comment_changeset: comment,
      subscription: subscription,
      users: Repo.all(User.active()),
      page_title: announcement.title
    )
  end

  def new(conn, _params) do
    conn
    |> page_title("New Announcement")
    |> render_form("new.html", %Announcement{})
  end

  def create(conn, %{"announcement" => announcement_params}) do
    {interest_names, announcement_params} = extract_interest_names(announcement_params)

    announcement_params =
      announcement_params
      |> Map.put("user_id", conn.assigns.current_user.id)

    case AnnouncementCreator.create(announcement_params, interest_names) do
      {:ok, announcement} ->
        redirect(conn, to: Routes.announcement_path(conn, :show, announcement))

      {:error, changeset} ->
        interests = Repo.all(Interest)

        render(conn, "new.html", %{
          changeset: changeset,
          interests: interests,
          users: Repo.all(User),
          page_title: "New Announcement"
        })
    end
  end

  def edit(conn, %{"id" => id}) do
    announcement = Repo.get!(Announcement, id) |> Repo.preload([:interests])

    conn
    |> page_title("Edit Announcement")
    |> render_form("edit.html", announcement)
  end

  def update(conn, %{"id" => id, "announcement" => announcement_params}) do
    current_user = conn.assigns.current_user
    announcement = Repo.get!(Announcement, id)

    {interest_names, announcement_params} = extract_interest_names(announcement_params)

    if announcement.user_id == current_user.id do
      case AnnouncementUpdater.update(announcement, announcement_params, interest_names) do
        {:ok, announcement} ->
          redirect(conn, to: Routes.announcement_path(conn, :show, announcement))

        {:error, _changeset} ->
          render_form(conn, "edit", announcement)
      end
    else
      conn
      |> put_flash(:error, gettext("You do not have permission to edit that announcement"))
      |> redirect(to: Routes.announcement_path(conn, :show, announcement))
    end
  end

  def delete(conn, %{"id" => id}) do
    current_user = current_user(conn)
    announcement = Repo.get!(Announcement, id)

    if announcement.user_id == current_user.id do
      Repo.delete!(announcement)

      conn
      |> put_flash(:info, gettext("Announcement deleted"))
      |> redirect(to: Routes.announcement_path(conn, :index))
    else
      conn
      |> put_flash(:error, gettext("You do not have permission to delete that announcement"))
      |> redirect(to: Routes.announcement_path(conn, :show, announcement))
    end
  end

  defp render_form(conn, action, announcement) do
    changeset = Announcement.create_changeset(announcement, %{})
    interests = Repo.all(Interest)
    users = Repo.all(User.active())

    render(conn, action, %{
      changeset: changeset,
      interests: interests,
      users: users
    })
  end

  defp extract_interest_names(announcement_params) do
    interest_names =
      Map.get(announcement_params, "interests")
      |> String.split(",")

    announcement_params =
      announcement_params
      |> Map.delete("interests")

    {interest_names, announcement_params}
  end

  defp my_announcements(conn) do
    conn.assigns.current_user
    |> Ecto.assoc(:interesting_announcements)
    |> Announcement.with_announcement_list_assocs()
    |> Announcement.last_discussed_first()
  end

  defp all_announcements do
    Announcement.with_announcement_list_assocs()
    |> Announcement.last_discussed_first()
  end

  defp preload_interests(user) do
    Repo.preload(user, :interests)
  end
end
