defmodule Constable.ConnTestHelper do
  import Constable.Factories
  import Phoenix.ConnTest
  import Plug.Conn

  def authenticate(user \\ create(:user)) do
    conn = conn()
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
