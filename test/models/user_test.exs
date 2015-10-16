defmodule Constable.UserTest do
  use Constable.TestWithEcto

  alias Constable.User

  test "create_changeset sets token and username" do
    changeset = User.create_changeset(%User{}, %{
      email: "foo@thoughtbot.com",
      name: "Foo Bar"
    })

    assert changeset.valid?
    assert changeset.changes.username == "foo"
    assert String.length(changeset.changes.token) == 43
  end

  test "create_changeset validates email ends with thoughtbot.com" do
    changeset = User.create_changeset(%User{}, %{
      email: "bcardella@dockyard.com",
      name: "Foo Bar"
    })

    refute changeset.valid?
    assert changeset.errors[:email] == "must be a member of thoughtbot"
  end
end
