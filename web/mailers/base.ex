defmodule Constable.Mailers.Base do
  def default_attributes(announcement: announcement, author: author) do
    %{
      from_email: "constable-#{announcement.id}@#{email_domain}",
      from_name: "#{author.name} (Constable)"
    }
  end

  def default_bindings do
    [front_end_uri: System.get_env("FRONT_END_URI"),
     back_end_uri: "http://#{back_end_host}"]
  end

  def email_domain do
    System.get_env("EMAIL_DOMAIN")
  end

  def back_end_host do
    Application.get_env(:constable, Constable.Endpoint) |> get_in([:url, :host])
  end
end
