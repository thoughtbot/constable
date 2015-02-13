defmodule ConstableApi.Mailers.Announcement do
  alias ConstableApi.User
  alias ConstableApi.Repo
  alias ConstableApi.Mandrill

  @template_base "web/templates/mailers/announcements"

  def created(announcement) do
    message_params = %{
      text: render_template("new", [
        announcement: announcement,
        author: announcement.user
      ]),
      subject: "#{announcement.title}",
      from_email: "paul@thoughtbot.com",
      from_name: "Constable Announcement",
      to: Mandrill.format_users(Repo.all(User)),
      tags: ["new-announcement"]
    }
    |> Pact.get(:mailer).message_send
  end

  defp render_template(path, bindings) do
    EEx.eval_file("#{@template_base}/#{path}.eex", bindings)
  end
end
