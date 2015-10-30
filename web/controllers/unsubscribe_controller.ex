defmodule Constable.UnsubscribeController do
  use Constable.Web, :controller

  alias Constable.Subscription

  def show(conn, %{"id" => token}) do
    if subscription = Repo.get_by(Subscription, token: token) do
      Repo.delete(subscription)
    end

    render(conn, "show.html")
  end
end
