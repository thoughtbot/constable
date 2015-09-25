defmodule Constable.UnsubscribeController do
  use Phoenix.Controller

  alias Constable.Subscription
  alias Constable.Repo

  def show(conn, %{"id" => token}) do
    if subscription = Repo.get_by(Subscription, token: token) do
      Repo.delete(subscription)
    end

    render(conn, "show.html")
  end
end
