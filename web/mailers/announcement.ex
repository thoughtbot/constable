defmodule Constable.Mailers.Announcement do
  alias Constable.User
  alias Constable.Repo
  alias Constable.Mandrill

  @template_base "web/templates/mailers/announcements"

  def created(announcement) do
    message_params = %{
      text: render_template("new", [
        announcement: announcement,
        author: announcement.user
      ]),
      subject: "#{announcement.title}",
      from_email: "noreply@constable.io",
      from_name: "#{announcement.user.name} (Constable)",
      to: Mandrill.format_users(Repo.all(User)),
      tags: ["new-announcement"]
    }
    |> Pact.get(:mailer).message_send
  end

  defp render_template(path, bindings) do
    EEx.eval_file("#{@template_base}/#{path}.eex", bindings)
  end
end
