defmodule Constable.Api.UserInterestViewTest do
  use Constable.ViewCase, async: true
  alias Constable.Api.UserInterestView

  test "show.json returns correct fields" do
    user = Forge.user
    interest = Forge.interest
    user_interest = Forge.user_interest(user: user, interest: interest)

    rendered_user_interest = render_one(user_interest, UserInterestView, "show.json")

    assert rendered_user_interest == %{
      data: %{
        id: user_interest.id,
        interest_id: interest.id,
        user_id: user.id,
      }
    }
  end
end
