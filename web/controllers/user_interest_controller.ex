defmodule Constable.UserInterestController do
  use Constable.Web, :controller

  alias Constable.UserInterest

  def create(conn, %{"interest_id" => interest_id}) do
    current_user = current_user(conn)

    UserInterest.changeset(%{user_id: current_user.id, interest_id: interest_id})
    |> Repo.insert!

    send_resp(conn, :no_content, "")
  end

  def delete(conn, %{"interest_id" => interest_id}) do
    UserInterest
    |> Repo.get_by!(interest_id: interest_id, user_id: current_user(conn).id)
    |> Repo.delete!

    send_resp(conn, :no_content, "")
  end
end
