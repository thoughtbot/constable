defmodule Constable.Repo.Migrations.MakeAnnouncementSlugsNonNullable do
  use Ecto.Migration

  alias Constable.{Announcement, Repo}
  import Ecto.Query, only: [from: 2]

  def change do
    Announcement
    |> Repo.all()
    |> Enum.each(fn announcement ->
      slug = Slugger.slugify_downcase(announcement.title)

      query =
        from(
          a in Announcement,
          where: a.id == ^announcement.id,
          update: [set: [slug: ^slug]]
        )

      Repo.update_all(query, [])
    end)

    alter table(:announcements) do
      modify(:slug, :string, null: false)
    end
  end
end
