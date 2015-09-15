defmodule Constable.MandrillTest do
  use ExUnit.Case, async: true

  alias Constable.Mandrill

  test "returns map with email, name, and type" do
    user = Constable.Factories.build(:user)

    users_as_json = Mandrill.format_users([user])

    assert users_as_json == [%{
      email: user.email,
      name: user.name,
      type: "bcc"
    }]
  end
end
