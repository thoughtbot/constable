defmodule Constable.EmailView do
  use Constable.Web, :view

  def red do
    "#c32f34"
  end

  def light_gray do
    "#aeaeae"
  end

  def unsubscribe_link do
    back_end_uri <> "/unsubscribe/{{subscription_id}}"
  end

  def front_end_uri do
    System.get_env("FRONT_END_URI")
  end

  def author_avatar_url(user) do
    Exgravatar.generate(user.email)
  end

  defp back_end_uri do
    "http://#{back_end_host}"
  end

  defp back_end_host do
    Application.get_env(:constable, Constable.Endpoint) |> get_in([:url, :host])
  end
end
