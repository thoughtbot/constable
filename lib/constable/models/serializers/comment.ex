defimpl Poison.Encoder, for: Constable.Comment do
  alias Constable.Repo

  @attributes ~W(id body user reactions announcement_id inserted_at)a

  def encode(comment, _options) do
    comment |> Repo.preload([:reactions]) |> Map.take(@attributes) |> Poison.encode!()
  end
end
