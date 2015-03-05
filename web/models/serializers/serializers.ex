defmodule Constable.Serializers do
  def ids_as_keys(objects) do
    Enum.reduce(objects, %{}, fn(object, objects) ->
      Map.put(objects, to_string(object.id), object)
    end)
  end
end
