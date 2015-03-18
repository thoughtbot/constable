defimpl Poison.Encoder, for: Constable.Announcement do
  @attributes ~W(id title body user comments interests inserted_at updated_at)a

  def encode(announcement, _options) do
    announcement |> Map.take(@attributes) |> Poison.encode!
  end
end
