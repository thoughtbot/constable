defmodule Constable.Mailers.Comment do
  alias Constable.User
  alias Constable.Repo
  alias Constable.Mandrill

  @template_base "web/templates/mailers/comments"

  def created(comment, users) do
    message_params = %{
      text: render_template("new", [
        comment: comment,
        author: comment.user
      ]),
      subject: "Re: #{comment.announcement.title}",
      from_email: "noreply@constable.io",
      from_name: "#{comment.user.name} (Constable)",
      to: Mandrill.format_users(users),
      tags: ["new-comment"]
    }
    |> Pact.get(:mailer).message_send
  end

  defp render_template(path, bindings) do
    EEx.eval_file("#{@template_base}/#{path}.eex", bindings)
  end
end
