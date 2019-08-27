defmodule Constable.Repo.Migrations.CreateReactions do
  use Ecto.Migration

  def change do
    create table(:reactions) do
      add :emoji, :string, null: false
      add :user_id, references("users", on_delete: :delete_all, on_replace: :delete), null: false

      timestamps()
    end

    create table(:announcement_reactions) do
      add :announcement_id,
          references(:announcements, on_delete: :delete_all, on_replace: :delete)

      add :reaction_id, references(:reactions, on_delete: :delete_all, on_replace: :delete)
    end

    create unique_index(:announcement_reactions, [:announcement_id, :reaction_id])

    create table(:comment_reactions) do
      add :comment_id, references(:comments, on_delete: :delete_all, on_replace: :delete)
      add :reaction_id, references(:reactions, on_delete: :delete_all, on_replace: :delete)
    end

    create unique_index(:comment_reactions, [:comment_id, :reaction_id])
  end
end
