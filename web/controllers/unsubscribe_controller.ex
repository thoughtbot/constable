defmodule Constable.UnsubscribeController do
  use Phoenix.Controller

  alias Constable.Subscription
  alias Constable.Repo

  def show(conn, %{"id" => token}) do
    subscription = Repo.get_by!(Subscription, token: token)
    Repo.delete(subscription)

    conn |> redirect(external: System.get_env("FRONT_END_URI"))
  end
end
