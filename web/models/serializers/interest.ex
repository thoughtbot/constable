defimpl Poison.Encoder, for: Constable.Interest do
  def encode(interest, _options) do
    %{
      id: interest.id,
      name: interest.name
    } |> Poison.encode!
  end
end
