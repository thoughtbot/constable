defmodule Constable.UserInterestViewTest do
  use Constable.ViewCase, async: true

  test "returns the user and interest ids" do
    user_interest = Forge.user_interest(id: 1, user_id: 1, interest_id: 2)

    rendered_user_interest =
      UserInterestView.render("show.json", %{user_interest: user_interest})

    assert rendered_user_interest == %{
      id: 1,
      user_id: 1,
      interest_id: 2
    }
  end
end
