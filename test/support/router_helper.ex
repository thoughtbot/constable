defmodule RouterHelper do
  @moduledoc """
  Conveniences for testing routers and controllers.

  Must not be used to test endpoints as it does some
  pre-processing (like fetching params) which could
  skew endpoint tests.
  """

  import Plug.Test
  import ExUnit.CaptureIO

  @session Plug.Session.init(
    store: :cookie,
    key: "_app",
    encryption_salt: "yadayada",
    signing_salt: "yadayada"
  )

  defmacro __using__(_) do
    quote do
      use Plug.Test
      import RouterHelper
      import Constable.Router.Helpers
      import Constable.ControllerHelpers
    end
  end

  def call_router(conn) do
    conn |> Constable.Router.call(Constable.Router.init([]))
  end

  def phoenix_conn(verb, path \\ "/", params \\ nil, headers \\ []) do
    conn = conn(verb, path, params, headers)
    |> Plug.Conn.fetch_params
    |> with_session
  end

  def call_controller(conn, controller, action) do
    controller.call(conn, controller.init(action))
  end

  def with_session(conn) do
    conn
    |> Map.put(:secret_key_base, String.duplicate("abcdefgh", 8))
    |> Plug.Session.call(@session)
    |> Plug.Conn.fetch_session()
  end
end
