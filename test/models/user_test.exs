defmodule Constable.UserTest do
  use Constable.TestWithEcto, async: true

  alias Constable.User

  test "settings_changeset validates length of name" do
    changeset = User.settings_changeset(%User{}, %{name: "ab"})

    refute changeset.valid?
    assert changeset.errors[:name]
  end

  test "create_changeset returns invalid changeset" do
    changeset = User.create_changeset(%User{}, %{email: nil, name: nil})

    refute changeset.valid?
  end

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
    assert changeset.errors[:email] == {"must be a member of thoughtbot", []}
  end

  test "create_changeset sets name from username only if the name is blank" do
    changeset = User.create_changeset(%User{}, %{email: "foo@thoughtbot.com", name: "Real Name"})
    assert changeset.changes[:name] == "Real Name"

    username = "foobar"
    changeset = User.create_changeset(%User{}, %{email: username <> "@thoughtbot.com"})
    assert changeset.changes[:name] == username
  end
end
