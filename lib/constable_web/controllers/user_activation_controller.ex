defmodule ConstableWeb.UserActivationController do
  use Constable.Web, :controller

  alias Constable.{Repo, User}

  def index(conn, _params) do
    users = Repo.all(User |> order_by(desc: :active))
    render(conn, "index.html", users: users)
  end

  def update(conn, %{"id" => id}) do
    user = Repo.get!(User, id)
    new_activation_status = !user.active

    Ecto.Changeset.change(user, %{active: new_activation_status})
    |> Repo.update!

    redirect(conn, to: user_activation_path(conn, :index))
  end
end
