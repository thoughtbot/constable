defmodule Constable.RepoTest do
  use Constable.ModelCase
  alias Constable.Announcement

  test "Repo.count/1 return the count of all models" do
    author = Forge.saved_user(Repo)
    Forge.saved_announcement(Repo, user_id: author.id)
    Forge.saved_announcement(Repo, user_id: author.id)

    assert Repo.count(Announcement) == 2
  end
end
