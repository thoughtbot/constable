defmodule ConstableApi.Repo.Migrations.AddUserToComments do
  use Ecto.Migration

  def change do
    alter table(:comments) do
      add :user_id, references(:users), null: false
    end
  end
end
