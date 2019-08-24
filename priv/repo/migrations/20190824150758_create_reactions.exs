defmodule Constable.Repo.Migrations.CreateReactions do
  use Ecto.Migration

  def change do
    create table(:announcement_reactions) do
      add :emoji, :string, null: false
      add :user_id, references("users"), null: false
      add :reactable_id, references("announcements"), null: false

      timestamps()
    end

    create unique_index(:announcement_reactions, [:user_id, :reactable_id, :emoji])

    create table(:comment_reactions) do
      add :emoji, :string, null: false
      add :user_id, references("users"), null: false
      add :reactable_id, references("comments"), null: false

      timestamps()
    end

    create unique_index(:comment_reactions, [:user_id, :reactable_id, :emoji])
  end
end
