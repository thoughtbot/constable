defmodule Constable.Repo.Migrations.CreateAnnouncementsInterests do
  use Ecto.Migration

  def change do
    create table(:announcements_interests) do
      add :announcement_id, references(:announcement)
      add :interest_id, references(:interests)

      timestamps
    end

    create index(
      :announcements_interests,
      [:announcement_id, :interest_id],
      unique: true
    )
  end
end
