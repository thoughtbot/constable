defmodule Constable.Mailers.Comment do
  alias Constable.User
  alias Constable.Repo
  alias Constable.Mandrill
  import Constable.Mailers.Base

  @template_base "web/templates/mailers/comments"

  def created(comment, users) do
    default_attributes(announcement: comment.announcement, author: comment.user)
    |> Map.merge(%{
      html: email_html(comment),
      subject: "Re: #{comment.announcement.title}",
      to: Mandrill.format_users(users),
      tags: ["new-comment"]
    })
    |> Pact.get(:mailer).message_send
  end

  defp email_html(comment) do
    render_template("new",
      comment: comment,
      author: comment.user,
      author_avatar_url: Exgravatar.generate(comment.user.email)
    )
  end

  defp render_template(path, bindings) do
    binding = Dict.merge(default_bindings, bindings)
    EEx.eval_file("#{@template_base}/#{path}.eex", bindings)
  end
end
