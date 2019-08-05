defmodule ConstableWeb.AnnouncementLive do
  use Phoenix.LiveView
  use Phoenix.HTML

  import Ecto.Query

  alias Constable.Announcement
  alias Constable.Interest
  alias Constable.Repo
  alias Constable.User
  alias ConstableWeb.Router.Helpers, as: Routes

  @endpoint ConstableWeb.Endpoint

  def render(assigns) do
    ConstableWeb.AnnouncementView.render("new_live.html", assigns)
  end

  def mount(params, socket) do
    %{csrf_token: csrf_token} = params

    socket
    |> assign(:changeset, Announcement.create_changeset(%Announcement{}, %{}))
    |> assign(:interests, Repo.all(Interest))
    |> assign(:users, Repo.all(User.active()))
    |> assign(:path, Routes.announcement_path(@endpoint, :create))
    |> assign(:interest_names, [])
    |> assign(:interested_user_names, [])
    |> assign(:title_preview, "Title Preview")
    |> assign(:body_preview, "Your rendered markdown goes here")
    |> assign(:csrf_token, csrf_token)
    |> ok()
  end

  def handle_event("update_interests", %{"interests" => interests}, socket) do
    {interest_names, user_names} = get_interests(interests)

    socket
    |> assign(:interest_names, interest_names)
    |> assign(:interested_user_names, user_names)
    |> no_reply()
  end

  def handle_event("render_preview", params, socket) do
    %{"announcement" => %{"body" => body, "title" => title}} = params
    title_preview = Constable.Markdown.to_html(title)
    body_preview = Constable.Markdown.to_html(body)

    socket
    |> assign(:changeset, Announcement.create_changeset(%Announcement{}, params["announcement"]))
    |> assign(:title_preview, title_preview)
    |> assign(:body_preview, body_preview)
    |> no_reply()
  end

  defp get_interests(interests) do
    interest_names = String.split(interests, [",", ", "], trim: true)

    {interest_names, interested_user_names(interest_names)}
  end

  defp interested_user_names(interest_names) do
    query =
      from u in User,
        distinct: true,
        join: i in assoc(u, :interests),
        order_by: u.name,
        select: u.name,
        where: u.active == true,
        where: i.name in ^interest_names

    Repo.all(query)
  end

  defp ok(socket), do: {:ok, socket}

  defp no_reply(socket), do: {:noreply, socket}
end
