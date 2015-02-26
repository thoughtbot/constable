defmodule Constable.Serializers.AnnouncementTest do
  use ExUnit.Case, async: true
  alias Constable.Serializers

  test "returns map with id, title, body, user and embedded comments" do
    user = Forge.user
    interest = Forge.interest
    announcement = Forge.announcement(user: user, interests: [interest])
    comment = Forge.comment(announcement: announcement, user: user)
    announcement = Map.put(announcement, :comments, [comment])

    announcement_as_json = Serializers.to_json(announcement)

    assert announcement_as_json == %{
      id: announcement.id,
      title: announcement.title,
      body: announcement.body,
      user: Serializers.to_json(user),
      comments: [Serializers.to_json(comment)],
      interests: [Serializers.to_json(interest)],
      inserted_at: Ecto.DateTime.to_string(announcement.inserted_at),
      updated_at: Ecto.DateTime.to_string(announcement.updated_at)
    }
  end
end
