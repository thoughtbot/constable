defmodule ConstableApi.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :body, :text, null: false
      add :announcement_id, references(:announcement)

      timestamps
    end
  end
end
