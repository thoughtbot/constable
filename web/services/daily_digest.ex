defmodule Constable.DailyDigest do
  alias Constable.Repo
  alias Constable.Mandrill
  alias Constable.Announcement
  alias Constable.Interest
  import Ecto.Query
  import Constable.Mailers.Base

  @template_base "web/templates/mailers/daily_digest"

  def send_email(users, time) do
    if new_items_since?(time) do
      %{
        from_email: "constable@#{email_domain}",
        from_name: "Constable (thoughtbot)",
        html: email_html(time),
        text: email_text(time),
        subject: "Daily Digest",
        to: Mandrill.format_users(users),
        tags: ["daily-digest"]
      }
      |> Pact.get(:mailer).message_send_sync
    end
  end

  defp new_items_since?(time) do
    !Enum.empty?(announcements_since(time)) || !Enum.empty?(interests_since(time))
  end

  defp email_text(time) do
    render_template("digest.text",
      interests: interests_since(time),
      announcements: announcements_since(time)
    )
  end

  defp email_html(time) do
    render_template("digest.html",
      interests: interests_since(time),
      announcements: announcements_since(time)
    )
  end

  defp interests_since(time) do
    Repo.all(from i in Interest, where: i.inserted_at > ^time)
  end

  defp announcements_since(time) do
    Repo.all(from i in Announcement, where: i.inserted_at > ^time)
    |> Repo.preload(:user)
  end

  defp render_template(path, bindings) do
    bindings = Dict.merge(default_bindings, bindings)
    EEx.eval_file("#{@template_base}/#{path}.eex", bindings)
  end
end
