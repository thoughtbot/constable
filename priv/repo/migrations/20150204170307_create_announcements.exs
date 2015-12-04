defmodule Constable.Repo.Migrations.CreateAnnouncements do
  use Ecto.Migration

  def change do
    create table(:announcement) do
      add :title, :string
      add :body, :text

      timestamps
    end
  end
end
