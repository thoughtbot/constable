defmodule Constable.Mailers.Base do
  def default_attributes(author: author) do
    %{
      from_email: "announcements@#{outbound_domain}",
      from_name: "#{author.name} (Constable)"
    }
  end

  def default_bindings do
    [front_end_uri: System.get_env("FRONT_END_URI"),
     back_end_uri: "http://#{back_end_host}"]
  end

  def reply_to(message, email) do
    message |> Dict.put(:headers, %{ "Reply-To": email })
  end

  def announcement_email_address(announcement) do
    "announcement-#{announcement.id}@#{inbound_domain}"
  end

  def outbound_domain do
    Constable.Env.get("OUTBOUND_EMAIL_DOMAIN")
  end

  def inbound_domain do
    Constable.Env.get("INBOUND_EMAIL_DOMAIN")
  end

  def back_end_host do
    Application.get_env(:constable, Constable.Endpoint) |> get_in([:url, :host])
  end
end
