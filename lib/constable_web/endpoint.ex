defmodule ConstableWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :constable

  socket "/ws", ConstableWeb.UserSocket

  if Application.get_env(:constable, :sql_sandbox) do
    plug Phoenix.Ecto.SQL.Sandbox
  end

  plug Plug.Static,
    at: "/", from: :constable,
    gzip: true,
    only: ~w(css fonts images js favicon.ico)

  plug Plug.Logger

  # Code reloading will only work if the :code_reloader key of
  # the :phoenix application is set to true in your config file.
  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
  end

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Poison

  plug Plug.MethodOverride
  plug Plug.Head

  plug Plug.Session,
    store: :cookie,
    key: "_constable_key",
    signing_salt: "/CEisxlR"

  plug ConstableWeb.Router
end
