defimpl Poison.Encoder, for: Ecto.DateTime do
  def encode(date_time, _options) do
    date_time |> Ecto.DateTime.to_string |> Poison.encode!
  end
end
