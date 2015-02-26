defimpl Constable.Serializable, for: Constable.Announcement do
  alias Constable.Serializable

  def to_json(announcement) do
    %{
      id: announcement.id,
      title: announcement.title,
      body: announcement.body,
      user: Serializable.to_json(announcement.user),
      comments: Enum.map(announcement.comments, &Serializable.to_json/1),
      interests: Enum.map(announcement.interests, &Serializable.to_json/1),
      inserted_at: Ecto.DateTime.to_string(announcement.inserted_at),
      updated_at: Ecto.DateTime.to_string(announcement.updated_at),
    }
  end
end
