defmodule Constable.Repo.Migrations.AddNotNullConstraintToRequiredForeignKeys do
  use Ecto.Migration

  def up do
    alter table(:announcements_interests) do
      modify :interest_id, :integer, null: false
      modify :announcement_id, :integer, null: false
    end

    alter table(:comments) do
      modify :announcement_id, :integer, null: false
    end

    alter table(:users) do
      modify :email, :string, null: false
    end

    alter table(:users_interests) do
      modify :interest_id, :integer, null: false
      modify :user_id, :integer, null: false
    end
  end

  def down do
    alter table(:announcements_interests) do
      modify :interest_id, :integer, null: true
      modify :announcement_id, :integer, null: true
    end

    alter table(:comments) do
      modify :announcement_id, :integer, null: true
    end

    alter table(:users) do
      modify :email, :string, null: true
    end

    alter table(:users_interests) do
      modify :interest_id, :integer, null: true
      modify :user_id, :integer, null: true
    end
  end
end
