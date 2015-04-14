defmodule Constable.UserInterestChannel do
  use Constable.AuthorizedChannel
  alias Constable.UserInterest
  alias Constable.Repo
  alias Constable.Serializers

  def handle_in("all", _, socket) do
    user_interests = %{users_interests: Repo.all(UserInterest)}

    {:reply, {:ok, %{user_interests: user_interests}}, socket}
  end


  def handle_in("create", user_interest_params, socket) do
    user_interest =
      UserInterest.changeset(%UserInterest{}, user_interest_params)
     |> Repo.insert

     {:reply, user_interest, socket}
  end

  def handle_in("destroy", %{"id" => id}, socket) do
    Repo.get(UserInterest, id) |> Repo.delete

    {:reply, %{id: id}, socket}
  end
end
