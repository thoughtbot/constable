defmodule ConstableApi.Mailers.Comment do
  alias ConstableApi.User
  alias ConstableApi.Repo
  alias ConstableApi.Mandrill

  @template_base "web/templates/mailers/comments"

  def created(comment) do
    message_params = %{
      text: render_template("new", [
        comment: comment,
        author: comment.user
      ]),
      subject: "#{comment.announcement.title}",
      from_email: "paul@thoughtbot.com",
      from_name: "#{comment.user.name} (Constable)",
      to: Mandrill.format_users(Repo.all(User)),
      tags: ["new-comment"]
    }
    |> Pact.get(:mailer).message_send
  end

  defp render_template(path, bindings) do
    EEx.eval_file("#{@template_base}/#{path}.eex", bindings)
  end
end
