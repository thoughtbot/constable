defmodule Constable.Serializable.InterestsTest do
  use ExUnit.Case, async: true

  test "returns map with id and name" do
    interest = Forge.interest

    interest_as_json = Poison.encode!(interest)

    assert interest_as_json ==Poison.encode! %{
      id: interest.id,
      name: interest.name
    }
  end
end
