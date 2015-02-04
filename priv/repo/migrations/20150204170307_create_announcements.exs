defmodule ConstableApi.Repo.Migrations.CreateAnnouncements do
  use Ecto.Migration

  def change do
    create table(:announcement) do
      add :title
      add :body

      timestamps
    end
  end
end
