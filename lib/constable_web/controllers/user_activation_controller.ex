defmodule ConstableWeb.UserActivationController do
  use ConstableWeb, :controller

  alias Constable.{Repo, User, Profiles}

  def index(conn, _params) do
    users = Repo.all(User |> order_by(desc: :active))
    render(conn, "index.html", users: users)
  end

  def update(conn, %{"id" => id}) do
    user = Repo.get!(User, id)
    new_activation_status = !user.active

    user
    |> Ecto.Changeset.change(%{active: new_activation_status})
    |> Repo.update!()
    |> update_profile_info()

    redirect(conn, to: Routes.user_activation_path(conn, :index))
  end

  defp update_profile_info(user) do
    Constable.TaskSupervisor.one_off_task(fn -> Profiles.update_profile_info(user) end)
  end
end
