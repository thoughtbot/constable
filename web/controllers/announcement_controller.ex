defmodule Constable.AnnouncementController do
  use Constable.Web, :controller

  alias Constable.User
  alias Constable.Services.AnnouncementSubscriber
  alias Constable.Services.AnnouncementUpdater
  alias Constable.Services.SlackHook
  alias Constable.AnnouncementForm

  plug :scrub_params, "announcement" when action == :create

  alias Constable.{Announcement, Comment, Interest, Subscription}
  alias Constable.Services.AnnouncementCreator

  def index(conn, %{"all" => "true"} = params) do
    index_page = all_announcements |> Repo.paginate(params)

    conn
    |> assign(:announcements, index_page.entries)
    |> assign(:show_all, true)
    |> assign(:current_user, preload_interests(conn.assigns.current_user))
    |> assign(:index_page, index_page)
    |> render("index.html")
  end

  def index(conn, %{"interest" => interest, "page" => page}) do
    conn
    |> redirect(to: interest_path(conn, :show, interest, page: page))
  end

  def index(conn, params) do
    index_page = my_announcements(conn) |> Repo.paginate(params)

    conn
    |> assign(:announcements, index_page.entries)
    |> assign(:show_all, false)
    |> assign(:current_user, preload_interests(conn.assigns.current_user))
    |> assign(:index_page, index_page)
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
      subscription: subscription,
      users: Repo.all(User),
    )
  end

  def new(conn, _params) do
    render_form(conn, "new.html", %Announcement{})
  end

  def create(conn, %{"announcement" => announcement_params}) do
    changeset = AnnouncementForm.changeset(announcement_params)

    if changeset.valid? do
      multi = AnnouncementForm.create(changeset, conn.assigns.current_user)
      case Repo.transaction(multi) do
        {:ok, %{announcement: announcement}} ->
          redirect(conn, to: announcement_path(conn, :show, announcement.id))
        {:error, _failure, _changes} ->
          interests = Repo.all(Interest)
          users = Repo.all(User)

          conn
          |> put_flash(:error, gettext("Something went wrong"))
          |> render("new.html", %{
            changeset: changeset,
            interests: interests,
            users: users,
          })
      end
    else
      interests = Repo.all(Interest)
      users = Repo.all(User)

      render(conn, "new.html", %{
        changeset: changeset,
        interests: interests,
        users: users,
      })
    end
  end

  def edit(conn, %{"id" => id}) do
    announcement = Repo.get!(Announcement, id)
    render_form(conn, "edit.html", announcement)
  end

  def update(conn, %{"id" => id, "announcement" => announcement_params}) do
    current_user = conn.assigns.current_user
    announcement = Repo.get!(Announcement, id)

    {interest_names, announcement_params} = extract_interest_names(announcement_params)

    if announcement.user_id == current_user.id do
      case AnnouncementUpdater.update(announcement, announcement_params, interest_names) do
        {:ok, announcement} ->
          redirect(conn, to: announcement_path(conn, :show, announcement.id))
        {:error, changeset} ->
          render_form(conn, "edit", announcement)
      end
    else
      conn
      |> put_flash(:error, gettext("You do not have permission to edit that announcement"))
      |> redirect(to: announcement_path(conn, :show, announcement.id))
    end
  end

  defp render_form(conn, action, announcement) do
    changeset = if announcement.id do
      changeset = AnnouncementForm.changeset_from(announcement)
    else
      AnnouncementForm.changeset(%{})
    end

    interests = Repo.all(Interest)
    users = Repo.all(User)

    render(conn, action, %{
      changeset: changeset,
      interests: interests,
      users: users,
    })
  end

  defp extract_interest_names(announcement_params) do
    interest_names = Map.get(announcement_params, "interests")
      |> String.split(",")
    announcement_params = announcement_params
      |> Map.delete("interests")

    {interest_names, announcement_params}
  end

  defp my_announcements(conn) do
    conn.assigns.current_user
    |> Ecto.assoc(:interesting_announcements)
    |> Announcement.with_announcement_list_assocs
    |> Announcement.last_discussed_first
  end

  defp all_announcements do
    Announcement.with_announcement_list_assocs
    |> Announcement.last_discussed_first
  end

  defp preload_interests(user) do
    Repo.preload user, :interests
  end
end
