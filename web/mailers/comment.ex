defmodule Constable.Mailers.Comment do
  alias Constable.User
  alias Constable.Repo
  alias Constable.Mandrill
  import Constable.Mailers.Base

  @template_base "web/templates/mailers/comments"

  def created(comment, []), do: nil
  def created(comment, users) do
    default_attributes(announcement: comment.announcement, author: comment.user)
    |> Map.merge(%{
      html: created_html(comment),
      text: created_text(comment),
      subject: "Re: #{comment.announcement.title}",
      to: Mandrill.format_users(users),
      tags: ["new-comment"]
    })
    |> Pact.get(:mailer).message_send
  end

  def mentioned(comment, []), do: nil
  def mentioned(comment, users) do
    default_attributes(announcement: comment.announcement, author: comment.user)
    |> Map.merge(%{
      html: mentioned_html(comment),
      text: mentioned_text(comment),
      subject: "You were mentioned in: #{comment.announcement.title}",
      to: Mandrill.format_users(users),
      tags: ["mention"]
    })
    |> Pact.get(:mailer).message_send
  end

  defp created_text(comment) do
    render_template("new.text",
      comment: comment,
      author: comment.user,
    )
  end

  defp created_html(comment) do
    render_template("new.html",
      comment: comment,
      author: comment.user,
      author_avatar_url: Exgravatar.generate(comment.user.email)
    )
  end

  defp mentioned_text(comment) do
    render_template("mentioned.text",
      comment: comment,
      author: comment.user,
    )
  end

  defp mentioned_html(comment) do
    render_template("mentioned.html",
      comment: comment,
      author: comment.user,
      author_avatar_url: Exgravatar.generate(comment.user.email)
    )
  end

  defp render_template(path, bindings) do
    bindings = Dict.merge(default_bindings, bindings)
    EEx.eval_file("#{@template_base}/#{path}.eex", bindings)
  end
end
