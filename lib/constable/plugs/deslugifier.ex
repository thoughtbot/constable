defmodule Constable.Plugs.Deslugifier do
  def init(opts) do
    case Keyword.get(opts, :slugified_key) do
      nil -> raise "Must provide a :slugified_key to #{inspect __MODULE__}"
      key -> key
    end
  end

  def call(conn, key) do
    with {:ok, slugified_id} <- Map.fetch(conn.params, key),
         {:ok, id} <- deslugify(slugified_id)
    do
      put_in(conn, [Access.key!(:params), key], id)
    else
      _ -> conn
    end
  end

  defp deslugify(slugified_id) do
    case Integer.parse(slugified_id) do
      {int, _} when int > 0 -> {:ok, int}
      _ -> :error
    end
  end
end
