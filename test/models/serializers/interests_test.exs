defmodule Constable.Serializable.InterestsTest do
  use ExUnit.Case, async: true
  alias Constable.Serializers

  test "returns map with id and name" do
    interest = Forge.interest

    interest_as_json = Serializers.to_json(interest)

    assert interest_as_json == %{
      id: interest.id,
      name: interest.name
    }
  end
end
