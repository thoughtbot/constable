defmodule Constable.AuthView do
  use Constable.Web, :view

  alias Constable.Api.UserView

  def render("show.json", %{user: user}) do
    rendered_user = render_one(user, UserView, "show.json")
    rendered_user |> put_in([:user, :token], user.token)
  end
end
