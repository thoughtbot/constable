defmodule Constable.UserInterestTest do
  use Constable.TestWithEcto

  alias Constable.UserInterest

  test "validates uniqueness scoped user_id" do
    first_user = create(:user)
    second_user = create(:user)
    interest = create(:interest)

    assert Repo.insert! %UserInterest{user_id: first_user.id, interest_id: interest.id}
    assert Repo.insert! %UserInterest{user_id: second_user.id, interest_id: interest.id}
  end
end
