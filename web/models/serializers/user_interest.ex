defimpl Poison.Encoder, for: Constable.UserInterest do
  def encode(user_interest, _options) do
    %{
      id: user_interest.id,
      user_id: user_interest.user_id,
      interest_id: user_interest.interest_id
    } |> Poison.encode!
  end
end
