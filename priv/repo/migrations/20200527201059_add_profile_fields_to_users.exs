defmodule Constable.Repo.Migrations.AddProfileFieldsToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :profile_url, :string
      add :profile_image_url, :string
    end
  end
end
