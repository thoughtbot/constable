defmodule ConstableWeb.ViewCaseHelper do
  def ids_from(enumerable) do
    Enum.map(enumerable, fn(object) ->
      Map.get(object, :id)
    end)
  end
end
