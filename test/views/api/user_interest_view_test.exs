defmodule ConstableWeb.Api.UserInterestViewTest do
  use ConstableWeb.ViewCase, async: true
  alias ConstableWeb.Api.UserInterestView

  test "show.json returns correct fields" do
    user_interest = insert(:user_interest)

    rendered_user_interest = render_one(user_interest, UserInterestView, "show.json")

    assert rendered_user_interest == %{
      user_interest: %{
        id: user_interest.id,
        interest_id: user_interest.interest_id,
        user_id: user_interest.user_id,
      }
    }
  end
end
