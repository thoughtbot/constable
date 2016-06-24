defmodule Constable.EnumHelper do
  def pluck(enumerable, property) do
    Enum.map(enumerable, fn(object) ->
      Map.get(object, property)
    end)
  end
end
