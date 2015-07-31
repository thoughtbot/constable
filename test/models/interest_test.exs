defmodule Constable.InterestTest do
  use Constable.ModelCase
  alias Constable.Interest

  test "strips extra hashes from the interest name" do
    changeset = Interest.changeset(%{name: "##everyone"})
    assert changeset.valid?
    assert changeset.changes.name == "everyone"
  end
end
