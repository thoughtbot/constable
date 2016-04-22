defmodule Mix.Tasks.Constable.RefreshLastDiscussedAt do
  use Mix.Task
  alias Constable.Repo
  import Ecto.Query

  def run(_opts) do
    Mix.Task.run "app.start"

    for announcement <- Repo.all(Constable.Announcement) do
      latest_comment_inserted_at = announcement
        |> Ecto.assoc(:comments)
        |> limit(1)
        |> order_by(desc: :inserted_at)
        |> select([a], a.inserted_at)
        |> Repo.one

      last_discussed_at_params = %{
        last_discussed_at: latest_comment_inserted_at || announcement.inserted_at
      }

      announcement
      |> Ecto.Changeset.cast(last_discussed_at_params, [:last_discussed_at], [])
      |> Repo.update!
    end
  end
end
