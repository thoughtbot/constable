defimpl ConstableApi.Serializers, for: ConstableApi.Announcement do
  alias ConstableApi.Serializers

  def to_json(announcement) do
    %{
      id: announcement.id,
      title: announcement.title,
      body: announcement.body,
      comments: Enum.map(announcement.comments, &Serializers.to_json/1)
    }
  end
end
