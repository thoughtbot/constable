defmodule Constable.SharedView do
  def gravatar(user) do
    Exgravatar.generate(user.email, %{}, true)
  end
end
