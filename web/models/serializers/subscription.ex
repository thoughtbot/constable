defimpl Poison.Encoder, for: Constable.Subscription do
  def encode(subscription, _options) do
    %{
      id: subscription.id,
      user_id: subscription.user_id,
      announcement_id: subscription.announcement_id
    } |> Poison.encode!
  end
end
