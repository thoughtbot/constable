defmodule Constable.Api.UserInterestController do
  use Constable.Web, :controller

  alias Constable.UserInterest

  def index(conn, _params) do
    current_user = current_user(conn)
    user_interests = user_interests_for(current_user)

    render(conn, "index.json", user_interests: user_interests)
  end

  def show(conn, %{"id" => id}) do
    user_interest = Repo.get!(UserInterest, id)
    render conn, "show.json", user_interest: user_interest
  end

  def delete(conn, %{"id" => id}) do
    current_user = current_user(conn)
    user_interest = Repo.get!(UserInterest, id)

    if current_user.id == user_interest.user_id do
      Repo.delete!(user_interest)
      send_resp(conn, 204, "")
    else
      unauthorized(conn)
    end
  end

  defp user_interests_for(user) do
    Repo.all assoc(user, :user_interests)
  end
end
