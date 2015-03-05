defimpl Poison.Encoder, for: Constable.Announcement do
  alias Constable.Serializers

  def encode(announcement, _options) do
    %{
      id: announcement.id,
      title: announcement.title,
      body: announcement.body,
      user: announcement.user,
      comments: announcement.comments,
      interests: announcement.interests,
      inserted_at: announcement.inserted_at,
      updated_at: announcement.updated_at,
    } |> Poison.encode!
  end
end
