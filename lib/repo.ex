defmodule Constable.Repo do
  use Ecto.Repo,
    otp_app: :constable,
    adapter: Ecto.Adapters.Postgres
end
