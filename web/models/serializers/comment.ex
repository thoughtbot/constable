defimpl ConstableApi.Serializers, for: ConstableApi.Comment do
  alias ConstableApi.Serializers

  def to_json(comment) do
    %{
      id: comment.id,
      body: comment.body,
      user: Serializers.to_json(comment.user),
      announcement_id: comment.announcement_id
    }
  end
end
