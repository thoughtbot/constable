defmodule Constable.Plugs.Deslugifier do
  alias Constable.Slug

  def init(opts) do
    case Keyword.get(opts, :slugified_key) do
      nil -> raise "Must provide a :slugified_key to #{inspect(__MODULE__)}"
      key -> key
    end
  end

  def call(conn, key) do
    with {:ok, slugified_id} <- Map.fetch(conn.params, key),
         {:ok, id} <- Slug.deslugify(slugified_id) do
      put_in(conn, [Access.key!(:params), key], id)
    else
      _ -> conn
    end
  end
end
