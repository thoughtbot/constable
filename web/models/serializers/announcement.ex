defimpl ConstableApi.Serializers, for: ConstableApi.Announcement do
  alias ConstableApi.Serializers

  def to_json(announcement) do
    %{
      id: announcement.id,
      title: announcement.title,
      body: announcement.body,
      user: Serializers.to_json(announcement.user),
      comments: Enum.map(announcement.comments, &Serializers.to_json/1),
      inserted_at: Ecto.DateTime.to_string(announcement.inserted_at)
    }
  end
end
