defimpl Poison.Encoder, for: Constable.Announcement do
  alias Constable.Repo
  @attributes ~W(
    id
    title
    body
    user
    comments
    interests
    inserted_at
    updated_at
  )a

  def encode(announcement, _options) do
    announcement
    |> Repo.preload([:comments, :user, :interests])
    |> Map.take(@attributes)
    |> setInterests
    |> Poison.encode!
  end

  def setInterests(announcement) do
    interest_names = Enum.map(announcement.interests, fn (interest) -> interest.name end)
    Map.put(announcement, "interests", interest_names)
  end
end
