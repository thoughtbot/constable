defmodule Constable.Slug do
  def deslugify!(slugified_id) do
    case deslugify(slugified_id) do
      {:ok, int} -> int
      :error -> raise "Invalid slug"
    end
  end

  def deslugify(slugified_id) do
    case Integer.parse(slugified_id) do
      {int, _} when int > 0 -> {:ok, int}
      _ -> :error
    end
  end
end
