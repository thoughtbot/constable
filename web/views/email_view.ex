defmodule Constable.EmailView do
  use Constable.Web, :view

  def front_end_uri do
    System.get_env("FRONT_END_URI")
  end

  def back_end_uri do
    "http://#{back_end_host}"
  end

  def author_avatar_url(user) do
    Exgravatar.generate(user.email)
  end

  defp back_end_host do
    Application.get_env(:constable, Constable.Endpoint) |> get_in([:url, :host])
  end
end
