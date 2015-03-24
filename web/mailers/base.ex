defmodule Constable.Mailers.Base do
  @email_domain System.get_env("EMAIL_DOMAIN")
  def default_attributes(announcement: announcement, author: author) do
    %{
      from_email: "constable-#{announcement.id}@#{@email_domain}",
      from_name: "#{author.name} (Constable)"
    }
  end
end
