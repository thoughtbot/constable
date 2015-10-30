defmodule Constable.Mailers.Comment do
  alias Constable.Mandrill
  alias Constable.Repo
  alias Constable.Subscription

  import Constable.Mailers.Base

  @template_base "web/templates/mailers/comments"

  def created(_comment, []), do: nil
  def created(comment, users) do
    comment = comment |> Repo.preload([:announcement, :user])
    default_attributes(announcement: comment.announcement, author: comment.user)
    |> Map.merge(%{
      html: created_html(comment),
      text: created_text(comment),
      merge_language: "handlebars",
      subject: "Re: #{comment.announcement.title}",
      to: Mandrill.format_users(users),
      tags: ["new-comment"],
      merge_vars: generate_merge_vars(users, comment)
    })
    |> Pact.get(:mailer).message_send
  end

  def mentioned(_comment, []), do: nil
  def mentioned(comment, users) do
    comment = comment |> Repo.preload([:announcement, :user])
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

  defp generate_merge_vars(users, comment) do
    Enum.map(users, fn(user) ->
      subscription = Repo.get_by(Subscription,
        announcement_id: comment.announcement_id,
        user_id: user.id,
      )

      case subscription do
        nil -> %{}
        subscription -> generate_var(user, subscription)
      end
    end)
  end

  defp generate_var(user, subscription) do
    %{
      rcpt: user.email,
      vars: [
        %{
          name: "subscription_id",
          content: subscription.token
        }
      ]
    }
  end
end
