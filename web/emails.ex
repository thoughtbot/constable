defmodule Constable.Emails do
  use Bamboo.Phoenix, view: Constable.EmailView

  import Bamboo.MandrillHelper
  alias Constable.Repo
  alias Constable.Subscription

  def forwarded_email(%{"email" => to, "from_email" => from, "text" => email_body}) do
    new_email()
    |> to(admins())
    |> from(generic_address())
    |> put_header("Reply-To", from)
    |> text_body(forwarded_body(email_body, from, to))
  end

  defp admins do
    admin_emails() |> String.split(", ")
  end

  defp admin_emails do
    System.get_env("ADMIN_EMAILS") || raise "Need to set ADMIN_EMAILS env variable"
  end

  defp generic_address do
    "admin@#{outbound_domain()}"
  end

  defp forwarded_body(text_body, from_address, to) do
    """
    Originally from: #{from_address}
    Originally to: #{to}

    #{text_body}
    """
  end

  def new_announcement(announcement, recipients) do
    announcement = announcement |> Repo.preload([:user, :interests])
    new_email(to: recipients)
    |> subject(announcement.title)
    |> from_author(announcement.user)
    |> put_header("Reply-To", announcement_email_address(announcement))
    |> put_header("Message-ID", announcement_message_id(announcement))
    |> put_param("inline_css", true)
    |> tag("new-announcement")
    |> add_unsubscribe_vars(announcement)
    |> render(:new_announcement, %{
      announcement: announcement,
      author: announcement.user
    })
  end

  def new_comment(comment, recipients, mentioner \\ nil) do
    announcement = comment.announcement
    new_email(to: recipients)
    |> subject("Re: #{announcement.title}")
    |> from_author(comment.user)
    |> put_reply_headers(announcement)
    |> put_param("inline_css", true)
    |> tag("new-comment")
    |> add_unsubscribe_vars(announcement)
    |> render(:new_comment, %{
      announcement: announcement,
      comment: comment,
      author: comment.user,
      mentioner: mentioner
    })
  end

  def new_comment_mention(comment, recipients) do
    new_comment(comment, recipients, comment.user)
  end

  def new_announcement_mention(announcement, recipients) do
    announcement = announcement |> Repo.preload([:user, :interests])
    new_email(to: recipients)
    |> subject("You were mentioned in: #{announcement.title}")
    |> from_author(announcement.user)
    |> tag("new-announcement-mention")
    |> put_param("inline_css", true)
    |> put_header("Reply-To", announcement_email_address(announcement))
    |> put_header("Message-ID", announcement_message_id(announcement))
    |> render(:new_announcement,
      announcement: announcement,
      author: announcement.user
    )
  end

  def daily_digest(interests, announcements, comments, recipients) do
    new_email(to: recipients)
    |> subject("Daily Digest")
    |> from({"Constable (thoughtbot)", "constable@#{outbound_domain()}"})
    |> tag("daily-digest")
    |> render(:daily_digest,
      interests: interests,
      announcements: announcements,
      comments: comments
    )
  end

  defp add_unsubscribe_vars(email, announcement) do
    email
    |> put_param(:merge_language, "handlebars")
    |> put_param(:merge_vars, unsubscribe_vars(email.to, announcement))
  end

  defp unsubscribe_vars(recipients, announcement) do
    Enum.map(recipients, fn(recipient) ->
      subscription = Repo.get_by(Subscription,
        announcement_id: announcement.id,
        user_id: recipient.id,
      )

      case subscription do
        nil -> nil
        subscription -> subscription_merge_var(recipient, subscription)
      end
    end) |> Enum.reject(&is_nil/1)
  end

  defp subscription_merge_var(recipient, subscription) do
    %{
      rcpt: recipient.email,
      vars: [
        %{
          name: "subscription_id",
          content: subscription.token
        }
      ]
    }
  end

  defp put_reply_headers(email, announcement) do
    email
    |> put_header("In-Reply-To", announcement_message_id(announcement))
    |> put_header("Reply-To", announcement_email_address(announcement))
  end

  defp from_author(email, user) do
    from(email, {"#{user.name} (Constable)", from_email_address()})
  end

  defp from_email_address do
    "announcements@#{outbound_domain()}"
  end

  defp announcement_email_address(announcement) do
    "<announcement-#{announcement.id}@#{inbound_domain()}>"
  end

  defp announcement_message_id(announcement) do
    "<announcement-#{announcement.id}@#{outbound_domain()}>"
  end

  defp inbound_domain do
    Constable.Env.get("INBOUND_EMAIL_DOMAIN")
  end

  defp outbound_domain do
    Constable.Env.get("OUTBOUND_EMAIL_DOMAIN")
  end
end
