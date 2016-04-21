defmodule Constable.InterestController do
  use Constable.Web, :controller

  alias Constable.Interest

  def show(conn, %{"id" => id}) do
    interest = Repo.get!(Interest.with_announcements, id)
    render conn, "show.html", interest: interest
  end
end
