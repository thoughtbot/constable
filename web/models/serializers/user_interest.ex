defimpl Constable.Serializable, for: Constable.UserInterest do
  def to_json(user_interest) do
    %{
      id: user_interest.id,
      user_id: user_interest.user_id,
      interest_id: user_interest.interest_id
    }
  end
end
