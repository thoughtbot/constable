defmodule Constable.Repo.Migrations.AddNotificationSettingsToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :auto_subscribe, :boolean, default: false, null: false
      add :daily_digest, :boolean, default: true, null: false
    end
  end
end
