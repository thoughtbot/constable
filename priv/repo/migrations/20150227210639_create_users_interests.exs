defmodule Constable.Repo.Migrations.CreateUsersInterests do
  use Ecto.Migration

  def change do
    create table(:users_interests) do
      add :interest_id, references(:interests)
      add :user_id, references(:users)

      timestamps()
    end

    create index(
             :users_interests,
             [:interest_id, :user_id],
             unique: true
           )
  end
end
