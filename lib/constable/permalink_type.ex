defmodule Constable.PermalinkType do
  @behaviour Ecto.Type

  def type, do: :id

  def cast(integer) when is_integer(integer) do
    {:ok, integer}
  end

  def cast(string) when is_binary(string) do
    case Integer.parse(string) do
      {int, _} when int > 0 -> {:ok, int}
      _ -> :error
    end
  end

  def cast(_) do
    :error
  end

  def dump(integer) when is_integer(integer) do
    {:ok, integer}
  end

  def load(integer) when is_integer(integer) do
    {:ok, integer}
  end
end
