defimpl Poison.Encoder, for: Constable.Comment do
  @attributes ~W(id body user announcement_id inserted_at)a

  def encode(comment, _options) do
    comment |> Map.take(@attributes) |> Poison.encode!
  end
end
