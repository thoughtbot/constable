defimpl Constable.Serializable, for: Constable.Comment do
  alias Constable.Serializers

  def to_json(comment) do
    %{
      id: comment.id,
      body: comment.body,
      user: Serializers.to_json(comment.user),
      announcement_id: comment.announcement_id,
      inserted_at: Ecto.DateTime.to_string(comment.inserted_at)
    }
  end
end
