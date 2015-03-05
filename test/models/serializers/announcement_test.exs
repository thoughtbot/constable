defmodule Constable.AnnouncementSerializerTest do
  use ExUnit.Case, async: true
  alias Constable.Serializers

  test "returns map with id, title, body, user and embedded comments" do
    user = Forge.user
    interest = Forge.interest
    announcement = Forge.announcement(user: user, interests: [interest])
    comment = Forge.comment(announcement: announcement, user: user)
    announcement = Map.put(announcement, :comments, [comment])

    announcement_as_json = Poison.encode!(announcement)

    assert announcement_as_json == Poison.encode! %{
      id: announcement.id,
      title: announcement.title,
      body: announcement.body,
      user: announcement.user,
      comments: announcement.comments,
      interests: announcement.interests,
      inserted_at: announcement.inserted_at,
      updated_at: announcement.updated_at
    }
  end
end
