defmodule ConstableApi.Repo do
  use Ecto.Repo,
    otp_app: :constable_api,
    adapter: Ecto.Adapters.Postgres
end
