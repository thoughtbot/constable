defmodule ConstableApi.Repo.Migrations.AddUserToAnnouncements do
  use Ecto.Migration

  def up do
    alter table(:announcement) do
      add :user_id, references(:users), null: false
      modify :body, :text
    end
  end

  def down do
    alter table(:announcement) do
      remove :user_id
      modify :body, :string
    end
  end
end
