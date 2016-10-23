defmodule Constable.UserTest do
  use Constable.TestWithEcto, async: true

  alias Constable.User

  @permitted_email_domain Application.fetch_env!(:constable, :permitted_email_domain)
  @valid_email "foo@#{@permitted_email_domain}"

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
      email: @valid_email,
      name: "Foo Bar"
    })

    assert changeset.valid?
    assert changeset.changes.username == "foo"
    assert String.length(changeset.changes.token) == 43
  end

  test "create_changeset validates email is for permitted domain" do
    changeset = User.create_changeset(%User{}, %{
      email: "user@not_permitted.com",
      name: "Foo Bar"
    })

    refute changeset.valid?
    assert changeset.errors[:email] == {"must be a member of #{@permitted_email_domain}", []}
  end

  test "create_changeset sets name from username only if the name is blank" do
    changeset = User.create_changeset(%User{}, %{email: @valid_email, name: "Real Name"})
    assert changeset.changes[:name] == "Real Name"

    username = "foobar"
    changeset = User.create_changeset(%User{}, %{email: "#{username}@#{@permitted_email_domain}"})
    assert changeset.changes[:name] == username
  end
end
