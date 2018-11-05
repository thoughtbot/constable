defmodule Constable.Repo do
  use Ecto.Repo,
    otp_app: :constable,
    adapter: Ecto.Adapters.Postgres
  use Scrivener, page_size: 30
  import Ecto.Query

  @doc """
  Dynamically loads the repository url from the
  DATABASE_URL environment variable.
  """
  def init(_, opts) do
    {:ok, Keyword.put(opts, :url, System.get_env("DATABASE_URL"))}
  end

  def count(query) do
    one!(from record in query, select: count(record.id))
  end

  def count_distinct(query) do
    one!(from record in query, select: count(record.id, :distinct))
  end
end
