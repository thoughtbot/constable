defmodule ConstableWeb.RecipientsPreviewController do
  use Constable.Web, :controller

  alias Constable.User

  def show(conn, params) do
    interest_names = params["interests"] |> String.split(",", trim: true)

    conn
    |> put_status(200)
    |> render("show.json",
      interest_names: interest_names,
      interested_user_names: interested_user_names(interest_names)
    )
  end

  defp interested_user_names(interest_names) do
    query = from u in User,
              distinct: true,
              join: i in assoc(u, :interests),
              order_by: u.name,
              select: u.name,
              where: i.name in ^interest_names
    Repo.all(query)
  end
end
