defprotocol ConstableApi.Serializers do
  @doc "Returns a map of attributes"
  def to_json(record)
end
