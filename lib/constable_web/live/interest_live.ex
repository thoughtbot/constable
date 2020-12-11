defmodule ConstableWeb.InterestLive do
  use ConstableWeb, :live_view

  alias Constable.{Interest, User, UserInterest}

  def render(assigns) do
    render(ConstableWeb.InterestView, "index.html", assigns)
  end

  def mount(_, session, socket) do
    socket =
      socket
      |> assign(:current_user, fetch_user(session["current_user_id"]))
      |> assign(:interests, fetch_interests())

    {:ok, socket}
  end

  def handle_event("subscribe", %{"id" => id}, socket) do
    current_user = socket.assigns.current_user
    interest = Interest |> Repo.get!(id)

    UserInterest.changeset(%{user_id: current_user.id, interest_id: interest.id})
    |> Repo.insert!()

    user = fetch_user(current_user.id)

    {:noreply, assign(socket, current_user: user)}
  end

  def handle_event("unsubscribe", %{"id" => id}, socket) do
    current_user = socket.assigns.current_user
    interest = Interest |> Repo.get!(id)

    UserInterest
    |> Repo.get_by!(interest_id: interest.id, user_id: current_user.id)
    |> Repo.delete!()

    user = fetch_user(current_user.id)

    {:noreply, assign(socket, current_user: user)}
  end

  defp fetch_user(user_id) do
    User.active()
    |> Repo.get(user_id)
    |> Repo.preload(:interests)
  end

  defp fetch_interests do
    Repo.all(Interest.ordered_by_name())
  end
end
