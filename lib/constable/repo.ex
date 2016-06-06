defmodule Constable.Repo do
  import Ecto.Query
  use Ecto.Repo,
    otp_app: :constable,
    adapter: Ecto.Adapters.Postgres

  use Scrivener, page_size: 30

  def count(query) do
    one!(from record in query, select: count(record.id))
  end

  def count_distinct(query) do
    one!(from record in query, select: count(record.id, :distinct))
  end
end
