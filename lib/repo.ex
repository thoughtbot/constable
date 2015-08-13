defmodule Constable.Repo do
  import Ecto.Query
  use Ecto.Repo,
    otp_app: :constable,
    adapter: Ecto.Adapters.Postgres

  def count(query) do
    __MODULE__.all(from record in query, select: count(record.id))
    |> List.first
  end

  def get_or_insert(%{model: %{__struct__: model}, changes: changes} = changeset) do
    record = __MODULE__.get_by(model, changes)
    case record do
      nil -> __MODULE__.insert!(changeset)
      _ -> record
    end
  end
end
