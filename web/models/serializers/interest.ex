defimpl Constable.Serializable, for: Constable.Interest do
  def to_json(interest) do
    %{
      id: interest.id,
      name: interest.name
    }
  end
end
