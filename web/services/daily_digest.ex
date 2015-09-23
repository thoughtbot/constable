defmodule Constable.DailyDigest do
  alias Constable.Repo
  alias Constable.Mandrill
  alias Constable.Announcement
  alias Constable.Time
  alias Constable.Interest
  import Ecto.Query
  import Constable.Mailers.Base

  @template_base "web/templates/mailers/daily_digest"

  def send_email(users) do
    if length(new_announcements) > 0 do
      %{
        from_email: "constable@#{email_domain}",
        from_name: "Constable (thoughtbot)",
        html: email_html,
        text: email_text,
        subject: "Daily Digest",
        to: Mandrill.format_users(users),
        tags: ["daily-digest"]
      }
      |> Pact.get(:mailer).message_send_sync
    end
  end

  defp email_text do
    render_template("digest.text",
      interests: new_interests,
      announcements: new_announcements
    )
  end

  defp email_html do
    render_template("digest.html",
      interests: new_interests,
      announcements: new_announcements
    )
  end

  defp new_interests do
    Repo.all(from i in Interest, where: i.inserted_at > ^Time.yesterday)
  end

  defp new_announcements do
    Repo.all(from i in Announcement, where: i.inserted_at > ^Time.yesterday)
    |> Repo.preload(:user)
  end

  defp render_template(path, bindings) do
    bindings = Dict.merge(default_bindings, bindings)
    EEx.eval_file("#{@template_base}/#{path}.eex", bindings)
  end
end
