defmodule Constable.UserInterestTest do
  use Constable.ModelCase

  alias Constable.UserInterest

  test "validates uniqueness scoped user_id" do
    first_user = Forge.saved_user(Repo)
    second_user = Forge.saved_user(Repo)
    interest = Forge.saved_interest(Repo)

    assert Repo.insert! %UserInterest{user_id: first_user.id, interest_id: interest.id}
    assert Repo.insert! %UserInterest{user_id: second_user.id, interest_id: interest.id}
  end
end
