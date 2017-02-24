defmodule Constable.Repo.Migrations.CreateInterests do
  use Ecto.Migration

  def change do
    create table(:interests) do
      add :name, :string, null: false

      timestamps()
    end

    create index(:interests, [:name], unique: true)
  end
end
