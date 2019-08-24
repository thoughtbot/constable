defimpl Poison.Encoder, for: Constable.Reaction do
  @attributes ~W(id user_id reactable_id emoji inserted_at)a

  def encode(reaction, _options) do
    reaction |> Map.take(@attributes) |> Poison.encode!()
  end
end
