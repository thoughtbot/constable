defimpl ConstableApi.Serializers, for: ConstableApi.Comment do
  def to_json(comment) do
    %{
      id: comment.id,
      body: comment.body
    }
  end
end
