defimpl Constable.Serializable, for: Constable.Subscription do
  def to_json(subscription) do
    %{
      id: subscription.id,
      user_id: subscription.user_id,
      announcement_id: subscription.announcement_id
    }
  end
end
