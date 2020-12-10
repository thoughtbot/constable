defmodule ConstableWeb.AnnouncementLive do
  use ConstableWeb, :live_view

  alias Constable.{Announcement, Interest, User}

  def render(assigns) do
    render(ConstableWeb.AnnouncementView, "new.html", assigns)
  end

  def mount(_, _, socket) do
    changeset = Announcement.create_changeset(%Announcement{}, %{})
    interests = Repo.all(Interest)
    users = Repo.all(User.active())
    preview = "Preview"
    preview_title = "Preview"

    {:ok,
     assign(socket,
       preview_title: preview_title,
       preview: preview,
       changeset: changeset,
       interests: interests,
       users: users
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
end
