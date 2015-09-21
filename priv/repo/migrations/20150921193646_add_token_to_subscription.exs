defmodule Constable.Repo.Migrations.AddTokenToSubscription do
  use Ecto.Migration

  def change do
    alter table(:subscriptions) do
      add :token, :string
    end
  end
end
