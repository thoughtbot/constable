defmodule ConstableWeb.AuthViewTest do
  use ConstableWeb.ViewCase, async: true
  alias ConstableWeb.AuthView
  alias ConstableWeb.Api.UserView

  test "show.json returns correct fields" do
    user = insert(:user)

    rendered_user = render_one(user, AuthView, "show.json", as: :user)
    user_view_json = render_one(user, UserView, "show.json")
    user_with_token = user_view_json |> put_in([:user, :token], user.token)

    assert rendered_user == user_with_token
  end
end
