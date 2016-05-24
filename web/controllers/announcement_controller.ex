defmodule Constable.AnnouncementController do
  use Constable.Web, :controller

  alias Constable.User
  alias Constable.Services.AnnouncementUpdater

  plug :scrub_params, "announcement" when action == :create

  alias Constable.{Announcement, Comment, Interest, Subscription}
  alias Constable.Services.AnnouncementCreator

  def index(conn, %{"all" => "true"} = params) do
    conn
    |> assign(:announcements, all_announcements(page_number(params["page"])))
    |> assign(:page_number, page_number(params["page"]))
    |> assign(:show_all, true)
    |> assign(:current_user, preload_interests(conn.assigns.current_user))
    |> render("index.html")
  end
  def index(conn, params) do
    conn
    |> assign(:announcements, my_announcements(conn, page_number(params["page"])))
    |> assign(:page_number, page_number(params["page"]))
    |> assign(:show_all, false)
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
      subscription: subscription,
      users: Repo.all(User),
    )
  end

  def new(conn, _params) do
    render_form(conn, "new.html", %Announcement{})
  end

  def create(conn, %{"announcement" => announcement_params}) do
    {interest_names, announcement_params} = extract_interest_names(announcement_params)
    announcement_params = announcement_params
      |> Map.put("user_id", conn.assigns.current_user.id)

    case AnnouncementCreator.create(announcement_params, interest_names) do
      {:ok, announcement} ->
        redirect(conn, to: announcement_path(conn, :show, announcement.id))
      {:error, changeset} ->
        interests = Repo.all(Interest)
        render(conn, "new.html", %{
          changeset: changeset,
          interests: interests,
          user_json: Repo.all(User),
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
        {:error, _changeset} ->
          render_form(conn, "edit", announcement)
      end
    else
      conn
      |> put_flash(:error, gettext("You do not have permission to edit that announcement"))
      |> redirect(to: announcement_path(conn, :show, announcement.id))
    end
  end

  defp render_form(conn, action, announcement) do
    changeset = Announcement.changeset(announcement, :create)
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

  defp my_announcements(conn, page) do
    conn.assigns.current_user
    |> Ecto.assoc(:interesting_announcements)
    |> Announcement.with_announcement_list_assocs
    |> Announcement.last_discussed_first
    |> Announcement.paginate(page)
    |> Repo.all
  end

  defp all_announcements(page) do
    Announcement.with_announcement_list_assocs
    |> Announcement.last_discussed_first
    |> Announcement.paginate(page)
    |> Repo.all
  end

  defp preload_interests(user) do
    Repo.preload user, :interests
  end
end
