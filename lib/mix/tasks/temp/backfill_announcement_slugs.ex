defmodule Mix.Tasks.Temp.BackfillAnnouncementSlugs do
  use Mix.Task
  import Ecto.Query

  alias Constable.{Announcement, Repo}

  def run(_) do
    Mix.Task.run "app.start"

    Announcement
    |> Repo.all()
    |> Enum.each(fn announcement ->
      slug = Slugger.slugify_downcase(announcement.title)

      query =
        from(a in Announcement,
            where: a.id == ^announcement.id,
            update: [set: [slug: ^slug]]
            )

      Repo.update_all(query, [])
    end)
  end
end
