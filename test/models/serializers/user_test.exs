defmodule Constable.UserSerializerTest do
  use ExUnit.Case, async: true
  alias Constable.Serializers

  test "returns json with id, email, name, and gravatar_url" do
    user = Forge.user

    user_as_json = Poison.encode!(user)

    assert user_as_json == Poison.encode! %{
      id: user.id,
      email: user.email,
      name: user.name,
      gravatar_url: Exgravatar.generate(user.email),
      user_interests: user.user_interests,
      subscriptions: user.subscriptions
    }
  end
end
