defmodule Constable.Repo.Migrations.AddSubscriptionsTable do
  use Ecto.Migration

  def change do
    create table(:subscriptions) do
      add :user_id, references(:users), null: false
      add :announcement_id, references(:announcement), null: false

      timestamps
    end

    create index(:subscriptions, [:user_id, :announcement_id], unique: true)
  end
end
