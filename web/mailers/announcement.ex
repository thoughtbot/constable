defmodule Constable.Mailers.Announcement do
  alias Constable.User
  alias Constable.Repo
  alias Constable.Mandrill

  @template_base "web/templates/mailers/announcements"
  @tags ~w(new-announcement)

  def created(announcement) do
    %{
      from_email: "noreply@constable.io",
      from_name: "#{announcement.user.name} (Constable)",
      to: interested_users(announcement),
      subject: announcement.title,
      tags: @tags,
      text: render_template("new",
        announcement: announcement,
        author: announcement.user
      )
    }
    |> Pact.get(:mailer).message_send
  end

  def interested_users(announcement) do
    announcement
    |> Map.get(:interested_users)
    |> Mandrill.format_users
  end

  defp render_template(path, bindings) do
    EEx.eval_file("#{@template_base}/#{path}.eex", bindings)
  end
end
