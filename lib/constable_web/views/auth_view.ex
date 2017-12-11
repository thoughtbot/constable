defmodule ConstableWeb.AuthView do
  use Constable.Web, :view

  alias ConstableWeb.Api.UserView

  def render("show.json", %{user: user}) do
    rendered_user = render_one(user, UserView, "show.json")
    rendered_user |> put_in([:user, :token], user.token)
  end
end
