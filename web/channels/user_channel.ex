defmodule Constable.UserChannel do
  use Constable.AuthorizedChannel
  alias Constable.User
  alias Constable.Repo
  alias Constable.Serializers

  def handle_in("show", %{"id" => id}, socket) do
    if id == "me" do
      user_id = current_user_id(socket)
      user = Repo.get(User, user_id)
    else
      user = Repo.get(User, id)
    end

    user = Repo.preload(user, [:subscriptions, :user_interests])

    {:reply, {:ok, %{user: user}}, socket}
  end
end
