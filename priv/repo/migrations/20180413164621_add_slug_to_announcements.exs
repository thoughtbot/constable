defmodule Constable.Repo.Migrations.AddSlugToAnnouncements do
  use Ecto.Migration

  def change do
    alter table(:announcements) do
      add :slug, :string
    end
  end
end
