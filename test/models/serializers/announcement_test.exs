defmodule ConstableApi.Serializers.AnnouncementTest do
  use ExUnit.Case, async: true
  alias ConstableApi.Serializers

  test "returns map with id, title, body, user and embedded comments" do
    user = Forge.user
    announcement = Forge.announcement(user: user)
    comment = Forge.comment(announcement: announcement, user: user)
    announcement = Map.put(announcement, :comments, [comment])

    announcement_as_json = Serializers.to_json(announcement)

    assert announcement_as_json == %{
      id: announcement.id,
      title: announcement.title,
      body: announcement.body,
      user: Serializers.to_json(user),
      comments: [Serializers.to_json(comment)],
      inserted_at: Ecto.DateTime.to_string(announcement.inserted_at)
    }
  end
end
