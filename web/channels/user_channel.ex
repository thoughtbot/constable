defmodule Constable.UserChannel do
  use Constable.AuthorizedChannel
  alias Constable.User
  alias Constable.Repo

  def handle_in("show", %{"id" => "me"}, socket) do
    user = current_user(socket) |> preload_associations
    {:reply, {:ok, %{user: user}}, socket}
  end

  def handle_in("show", %{"id" => id}, socket) do
    user = Repo.get(User, id) |> preload_associations
    {:reply, {:ok, %{user: user}}, socket}
  end

  defp current_user(socket) do
    user_id = current_user_id(socket)
    Repo.get(User, user_id)
  end

  defp preload_associations(user) do
    Repo.preload(user, [:subscriptions, :user_interests])
  end
end
