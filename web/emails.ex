defmodule Constable.Emails do
  use Bamboo.Phoenix, view: Constable.EmailView

  import Bamboo.Email
  import Bamboo.MandrillHelper
  alias Constable.Repo
  alias Constable.Subscription

  def new_announcement(announcement, recipients) do
    new_email(to: recipients)
    |> subject(announcement.title)
    |> from_author(announcement.user)
    |> put_header("Reply-To", announcement_email_address(announcement))
    |> put_header("Message-ID", announcement_message_id(announcement))
    |> tag("new-announcement")
    |> render(:new_announcement, %{
      announcement: announcement,
      interests: interest_names(announcement),
      author: announcement.user
    })
  end

  def new_comment(comment, recipients) do
    announcement = comment.announcement
    new_email(to: recipients)
    |> subject("Re: #{announcement.title}")
    |> from_author(comment.user)
    |> put_reply_headers(announcement)
    |> tag("new-comment")
    |> add_unsubscribe_vars(comment)
    |> render(:new_comment, %{
      announcement: announcement,
      comment: comment,
      author: comment.user
    })
  end

  def new_comment_mention(comment, recipients) do
    announcement = comment.announcement
    new_email(to: recipients)
    |> subject("You were mentioned in: #{announcement.title}")
    |> from_author(comment.user)
    |> put_reply_headers(announcement)
    |> tag("new-comment-mention")
    |> render(:new_comment, %{
      announcement: announcement,
      comment: comment,
      author: comment.user
    })
  end

  def new_announcement_mention(announcement, recipients) do
    announcement = announcement |> Repo.preload([:user, :interests])
    new_email(to: recipients)
    |> subject("You were mentioned in: #{announcement.title}")
    |> from_author(announcement.user)
    |> tag("new-announcement-mention")
    |> put_header("Reply-To", announcement_email_address(announcement))
    |> put_header("Message-ID", announcement_message_id(announcement))
    |> render(:new_announcement,
      announcement: announcement,
      interests: interest_names(announcement),
      author: announcement.user
    )
  end

  def daily_digest(interests, announcements, recipients) do
    new_email(to: recipients)
    |> subject("Daily Digest")
    |> from({"Constable (thoughtbot)", "constable@#{outbound_domain}"})
    |> tag("daily-digest")
    |> render(:daily_digest,
      interests: interests,
      announcements: announcements
    )
  end

  defp add_unsubscribe_vars(email, comment) do
    email
    |> put_param(:merge_language, "handlebars")
    |> put_param(:merge_vars, unsubscribe_vars(email.to, comment))
  end

  defp unsubscribe_vars(recipients, comment) do
    Enum.map(recipients, fn(recipient) ->
      subscription = Repo.get_by(Subscription,
        announcement_id: comment.announcement_id,
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
    from(email, {"#{user.name} (Constable)", from_email_address})
  end

  defp interest_names(announcement) do
    announcement
    |> Repo.preload(:interests)
    |> Map.get(:interests)
    |> Enum.map(&("##{&1.name}"))
    |> Enum.join(", ")
  end

  defp from_email_address do
    "announcements@#{outbound_domain}"
  end

  defp announcement_email_address(announcement) do
    "<announcement-#{announcement.id}@#{inbound_domain}>"
  end

  defp announcement_message_id(announcement) do
    "<announcement-#{announcement.id}@#{outbound_domain}>"
  end

  defp inbound_domain do
    Constable.Env.get("INBOUND_EMAIL_DOMAIN")
  end

  defp outbound_domain do
    Constable.Env.get("OUTBOUND_EMAIL_DOMAIN")
  end
end
