defmodule Constable.UserInterestChannel do
  use Constable.AuthorizedChannel
  alias Constable.UserInterest
  alias Constable.Repo
  alias Constable.Serializers

  def handle_in("users_interests:index", _, socket) do
    user_interests = %{users_interests: Repo.all(UserInterest)}

    reply socket, "users_interests:index", user_interests
  end


  def handle_in("users_interests:create", user_interest_params, socket) do
    user_interest =
      UserInterest.changeset(%UserInterest{}, user_interest_params)
     |> Repo.insert

    reply socket, "users_interests:create", user_interest
  end

  def handle_in("users_interests:destroy", %{"id" => id}, socket) do
    Repo.get(UserInterest, id) |> Repo.delete

    reply socket, "users_interests:destroy", %{id: id}
  end
end
