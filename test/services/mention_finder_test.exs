defmodule Constable.Services.MentionFinderTest do
  use Constable.TestWithEcto, async: true

  alias Constable.Repo
  alias Constable.User
  alias Constable.Services.MentionFinder

  test "extracts users from text" do
    insert(:user, username: "machoman")
    body = "Hello @machoman and @hulkamania"

    user = Repo.one(User)
    assert MentionFinder.find_users(body) == [user]
  end
end
