defmodule Constable.Repo.Migrations.AddLastDiscussedToAnnouncements do
  use Ecto.Migration

  def up do
    rename table(:announcement), to: table(:announcements)

    alter table(:announcements) do
      add :last_discussed_at, :datetime
    end

    execute """
    UPDATE announcements
    SET last_discussed_at = inserted_at
    WHERE last_discussed_at IS NULL
    """

    alter table(:announcements) do
      modify :last_discussed_at, :datetime, null: false
    end
  end

  def down do
    rename table(:announcements), to: table(:announcement)

    alter table(:announcement) do
      remove :last_discussed_at
    end
  end
end
