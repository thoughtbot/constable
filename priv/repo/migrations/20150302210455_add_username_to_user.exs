defmodule Constable.Repo.Migrations.AddUsernameToUser do
  use Ecto.Migration
  alias Constable.Repo

  def up do
    alter table(:users) do
      add :username, :string
    end

    Constable.Repo.all(Constable.User)
    |> Enum.each(&add_username_to_user/1)

    alter table(:users) do
      modify :username, :string, null: false, unique: true
    end
  end

  def down do
    alter table(:users) do
      remove :username
    end
  end

  defp add_username_to_user(user) do
    username = String.split(user.email, "@", parts: 2) |> List.first
    user = %{user | username: username}
    Repo.update(user)
  end
end
