defmodule Constable.Repo do
  import Ecto.Query
  use Ecto.Repo,
    otp_app: :constable,
    adapter: Ecto.Adapters.Postgres
end
