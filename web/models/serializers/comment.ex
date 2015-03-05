defimpl Poison.Encoder, for: Constable.Comment do
  def encode(comment, _options) do
    %{
      id: comment.id,
      body: comment.body,
      user: comment.user,
      announcement_id: comment.announcement_id,
      inserted_at: comment.inserted_at
    } |> Poison.encode!
  end
end
