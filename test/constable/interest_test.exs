defmodule Constable.InterestTest do
  use Constable.DataCase, async: true
  alias Constable.Interest

  test "strips extra hashes from the interest name" do
    changeset = Interest.changeset(%{name: "##everyone"})
    assert changeset.valid?
    assert changeset.changes.name == "everyone"
  end

  test "replaces spaces in the interest name with dashes" do
    changeset = Interest.changeset(%{name: "this is an interest"})
    assert changeset.valid?
    assert changeset.changes.name == "this-is-an-interest"
  end
end
