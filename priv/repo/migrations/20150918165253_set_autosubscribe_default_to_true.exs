defmodule Constable.Repo.Migrations.SetAutosubscribeDefaultToTrue do
  use Ecto.Migration

  def up do
    alter table(:users) do
      modify :auto_subscribe, :boolean, default: true
    end
  end

  def down do
    alter table(:users) do
      modify :auto_subscribe, :boolean, default: false
    end
  end
end
