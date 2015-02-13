defprotocol ConstableApi.Serializers do
  @doc "Returns a map of attributes"
  def to_json(record)

  @doc "Returns a map of attributes for the given context"
  def to_json(record, context)
end
