defmodule AnnouncementTest do
  use ConstableApi.TestWithEcto, async: false
  alias ConstableApi.Comment
  alias ConstableApi.Announcement
  alias ConstableApi.Repo
  alias ConstableApi.Serializers

  test "returns map with id, title, body and embedded comments" do
    announcement = %Announcement{body: "foo"} |> Repo.insert
    comment = %Comment{body: "bar", announcement_id: announcement.id}
    |> Repo.insert
    announcement = announcement |> Repo.preload(:comments)

    announcement_as_json = Serializers.to_json(announcement)

    assert announcement_as_json == %{
      id: announcement.id,
      title: announcement.title,
      body: announcement.body,
      comments: [Serializers.to_json(comment)]
    }
  end
end
