defprotocol Constable.Serializable do
  @doc "Returns a map of attributes"
  def to_json(record)

  @doc "Returns a map of attributes for the given context"
  def to_json(record, context)
end

defmodule Constable.Serializers do
  alias Constable.Serializable

  def ids_as_keys(objects) do
    Enum.reduce(objects, %{}, fn(object, objects) ->
      Map.put(objects, to_string(object.id), object)
    end)
  end

  def to_json(record), do: Serializable.to_json(record)
  def to_json(record, context), do: Serializable.to_json(record, context)
end
