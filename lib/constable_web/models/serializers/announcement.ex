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
    |> set_interests
    |> Poison.encode!
  end

  def set_interests(announcement) do
    interest_names = Enum.map(announcement.interests, fn (interest) -> interest.name end)
    Map.put(announcement, "interests", interest_names)
  end
end
