defmodule Constable.Repo.Migrations.AddNullConstrainToUsername do
  use Ecto.Migration
  alias Constable.Repo

  def up do
    {:ok, %{rows: users}} = Ecto.Adapters.SQL.query(Repo, "SELECT id,email FROM users", [])

    Enum.each(users, fn([id, email]) ->
      [name, _] = String.split(email, "@")

      query = "UPDATE users SET username = $1 WHERE id = $2"
      Ecto.Adapters.SQL.query(Repo, query, [name, id])
    end)

    alter table(:users) do
      modify :username, :string, null: false
    end
  end

  def down do
    alter table(:users) do
      modify :username, :string, null: true
    end
  end
end
