defimpl Constable.Serializers, for: Constable.Announcement do
  alias Constable.Serializers

  def to_json(announcement) do
    %{
      id: announcement.id,
      title: announcement.title,
      body: announcement.body,
      user: Serializers.to_json(announcement.user),
      comments: Enum.map(announcement.comments, &Serializers.to_json/1),
      inserted_at: Ecto.DateTime.to_string(announcement.inserted_at),
      updated_at: Ecto.DateTime.to_string(announcement.updated_at)
    }
  end
end
