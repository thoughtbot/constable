defmodule Constable.Serializable.UserInterestTest do
  use ExUnit.Case, async: true

  test "it returns the user and interest ids" do
    user_interest = Forge.user_interest(id: 1, user_id: 1, interest_id: 2)

    user_interest_json = Poison.encode!(user_interest)

    assert user_interest_json == Poison.encode! %{
      id: 1,
      user_id: 1,
      interest_id: 2
    }
  end
end
