defmodule Constable.AuthView do
  use Constable.Web, :view

  def render("show.json", %{user: user}) do
    %{
      user: %{
        id: user.id,
        name: user.name,
        email: user.email,
        token: user.token,
      }
    }
  end
end
