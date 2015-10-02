defmodule Constable.AuthViewTest do
  use Constable.ViewCase
  alias Constable.AuthView

  test "show.json returns correct fields" do
    user = create(:user)

    rendered_user = render_one(user, AuthView, "show.json", as: :user)

    assert rendered_user == %{
      user: %{
        id: user.id,
        name: user.name,
        email: user.email,
        token: user.token,
      }
    }
  end
end
