defmodule ConstableWeb.ConnCaseHelper do
  import Constable.Factory
  import Phoenix.ConnTest
  import Plug.Conn

  def browser_authenticate(user \\ insert(:user)) do
    conn = build_conn()
    |> assign(:current_user, user)
    %{conn: conn, user: user}
  end

  def api_authenticate(user \\ insert(:user)) do
    conn = build_conn()
    |> put_req_header("accept", "application/json")
    |> put_req_header("authorization", user.token)
    %{conn: conn, user: user}
  end

  def fetch_json_ids(key, conn, status \\ 200) do
    records = json_response(conn, status)[key]
    Enum.map(records, fn(json) ->
      Map.get(json, "id")
    end)
  end

  def with_session(conn, session_params \\ []) do
    session_opts =
      Plug.Session.init(
        store: :cookie,
        key: "_app",
        encryption_salt: "abc",
        signing_salt: "abc"
      )

    conn
    |> Map.put(:secret_key_base, String.duplicate("abcdefgh", 8))
    |> Plug.Session.call(session_opts)
    |> Plug.Conn.fetch_session
    |> Plug.Conn.fetch_query_params
    |> put_session_params_in_session(session_params)
  end

  defp put_session_params_in_session(conn, session_params) do
    List.foldl(session_params, conn, fn ({key, value}, acc)
    -> Plug.Conn.put_session(acc, key, value) end)
  end

  defmacro render_json(template, assigns) do
    view = Module.get_attribute(__CALLER__.module, :view)
    quote do
      render_json(unquote(template), unquote(view), unquote(assigns))
    end
  end
  def render_json(template, view, assigns) do
    view.render(template, assigns) |> format_json
  end

  defp format_json(data) do
    data |> Poison.encode! |> Poison.decode!
  end
end
