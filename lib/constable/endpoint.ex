defmodule Constable.Endpoint do
  use Phoenix.Endpoint, otp_app: :constable

  socket "/ws", Constable.UserSocket

  plug Plug.Static,
    at: "/", from: :constable

  plug Plug.Logger

  # Code reloading will only work if the :code_reloader key of
  # the :phoenix application is set to true in your config file.
  if code_reloading? do
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
    signing_salt: "/CEisxlR",
    encryption_salt: "W5B5Vc1E"

  plug CORSPlug
  plug Constable.Router
end
