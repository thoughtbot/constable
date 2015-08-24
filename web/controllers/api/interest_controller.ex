defmodule Constable.Api.InterestController do
  use Constable.Web, :controller

  alias Constable.Interest

  def index(conn, _params) do
    interests = Repo.all(Interest)

    render(conn, "index.json", interests: interests)
  end

  def show(conn, %{"id" => id}) do
    interest = Repo.get!(Interest, id)
    render conn, "show.json", interest: interest
  end
end
