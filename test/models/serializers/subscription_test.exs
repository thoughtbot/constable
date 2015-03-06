defmodule Constable.SubscriptionSerializerTest do
  use ExUnit.Case, async: true

  test "returns json with id, user_id, and announcement_id" do
    subscription = Forge.subscription(id: 1, user_id: 2, announcement_id: 3)

    subscription_as_json = Poison.encode!(subscription)

    assert subscription_as_json == Poison.encode! %{
      id: 1,
      user_id: 2,
      announcement_id: 3
    }
  end
end
