defmodule Constable.AnnouncementSerializerTest do
  use ExUnit.Case, async: true
  alias Constable.Serializers

  # TODO: Because the serializer isn't serializing the assertion in the right
  # order, the test isn't passing. Update to use Phoenix Views and then write
  # a new test
  @tag :pending
  test "returns json with id, title, body, user and embedded comments" do
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
      interests: [interest.name],
      inserted_at: announcement.inserted_at,
      updated_at: announcement.updated_at
    }
  end
end
