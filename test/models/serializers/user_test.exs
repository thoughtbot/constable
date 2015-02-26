defmodule Constable.Serializers.UserTest do
  use ExUnit.Case, async: true
  alias Constable.Serializers

  test "returns map with id, email, name, and gravatar_url" do
    user = Forge.user

    user_as_json = Serializers.to_json(user)

    assert user_as_json == %{
      id: user.id,
      email: user.email,
      name: user.name,
      gravatar_url: Exgravatar.generate(user.email)
    }
  end

  test "returns map with email, name, and type" do
    user = Forge.user

    user_as_json = Serializers.to_json(user, :mandrill)

    assert user_as_json == %{
      email: user.email,
      name: user.name,
      type: "bcc"
    }
  end
end
