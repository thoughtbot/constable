defmodule Constable.RecipientsPreviewController do
  use Constable.Web, :controller

  alias Constable.Interest
  alias Constable.User

  def show(conn, params) do
    recipient_count = interested_user_count(params["interests"])

    conn
    |> put_status(200)
    |> render("show.json", recipient_count: recipient_count)
  end

  defp interested_user_count(comma_separated_interest_names) do
    comma_separated_interest_names
    |> String.split(",")
    |> count_interested_users
  end

  defp count_interested_users(interest_names) do
    query = from u in User,
              join: i in assoc(u, :interests),
              where: i.name in ^interest_names
    Repo.count_distinct(query)
  end
end
