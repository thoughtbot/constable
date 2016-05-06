defmodule Constable.RepoTest do
  use Constable.ModelCase
  alias Constable.Announcement

  test "Repo.count/1 return the count of all models" do
    insert_pair(:announcement)

    assert Repo.count(Announcement) == 2
  end
end
