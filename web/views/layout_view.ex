defmodule Constable.LayoutView do
  use Constable.Web, :view

  def gravatar(user) do
    Exgravatar.generate(user.email, %{}, true)
  end
end
