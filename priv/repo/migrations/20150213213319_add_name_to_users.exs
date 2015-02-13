defmodule ConstableApi.Repo.Migrations.AddNameToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :name, :string, null: false
    end
  end
end
