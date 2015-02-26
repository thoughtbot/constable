defmodule Constable.Serializable.InterestsTest do
  use ExUnit.Case, async: true
  alias Constable.Serializable

  test "returns map with id and name" do
    interest = Forge.interest

    interest_as_json = Serializable.to_json(interest)

    assert interest_as_json == %{
      id: interest.id,
      name: interest.name
    }
  end
end
