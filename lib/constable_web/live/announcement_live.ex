defmodule ConstableWeb.AnnouncementLive do
  use ConstableWeb, :live_view

  alias Constable.{Announcement, Interest, User}
  alias Constable.Services.AnnouncementCreator

  def render(assigns) do
    render(ConstableWeb.AnnouncementView, "new.html", assigns)
  end

  def mount(_, session, socket) do
    changeset = Announcement.create_changeset(%Announcement{}, %{})
    interests = Repo.all(Interest)
    users = Repo.all(User.active())
    preview_title = "Title Preview"
    preview = "Your rendered markdown goes here"

    {:ok,
     assign(socket,
       preview_title: preview_title,
       preview: preview,
       changeset: changeset,
       interests: interests,
       users: users,
       current_user_id: session["current_user_id"]
     )}
  end

  def handle_event("preview", %{"announcement" => params}, socket) do
    changeset = Announcement.create_changeset(%Announcement{}, params)

    socket =
      socket
      |> assign(:changeset, changeset)
      |> assign(:preview, ConstableWeb.SharedView.markdown_with_users(params["body"]))
      |> assign(:preview_title, params["title"])

    {:noreply, socket}
  end

  def handle_event("create", %{"announcement" => params}, socket) do
    {interest_names, announcement_params} = extract_interest_names(params)

    announcement_params =
      announcement_params
      |> Map.put("user_id", socket.assigns.current_user_id)

    case AnnouncementCreator.create(announcement_params, interest_names) do
      {:ok, announcement} ->
        socket = push_redirect(socket, to: Routes.announcement_path(socket, :show, announcement))
        {:noreply, socket}

      {:error, changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp extract_interest_names(announcement_params) do
    interest_names =
      Map.get(announcement_params, "interests")
      |> String.split(",", trim: true)

    announcement_params =
      announcement_params
      |> Map.delete("interests")

    {interest_names, announcement_params}
  end
end
