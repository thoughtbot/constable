defmodule Elixir.Constable.Repo.Migrations.AddActiveToUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :active, :boolean, default: true, null: false
    end

    create index(:users, [:id, :active])
  end
end
