defmodule Constable.Repo.Migrations.AddSlackWebhookToInterest do
  use Ecto.Migration

  def change do
    alter table(:interests) do
      add :slack_channel, :string
    end
  end
end
