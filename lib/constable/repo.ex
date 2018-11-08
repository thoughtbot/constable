defmodule Constable.Repo do
  use Ecto.Repo,
    otp_app: :constable,
    adapter: Ecto.Adapters.Postgres

  use Scrivener, page_size: 30
  import Ecto.Query

  def count(query) do
    one!(from record in query, select: count(record.id))
  end
end
