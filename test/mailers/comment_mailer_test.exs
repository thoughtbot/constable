defmodule Constable.Mailers.CommentMailerTest do
  use Constable.TestWithEcto, async: true
  alias Constable.Emails
  alias Constable.Services.HubProfile

  test "new comment email" do
    author = insert(:user)
    user = insert(:user)
    announcement = insert(:announcement, user: author)
    subscription = insert(:subscription, user: user, announcement: announcement)
    comment = insert(:comment, user: author, announcement: announcement)
    users = [author, user]

    email = Emails.new_comment(comment, users)

    subject = "Re: #{announcement.title}"
    from_name = "#{author.name} (Constable)"
    from_email = "announcements@#{Constable.Env.get("OUTBOUND_EMAIL_DOMAIN")}"

    headers = %{
      "In-Reply-To" =>
        "<announcement-#{announcement.id}@#{Constable.Env.get("OUTBOUND_EMAIL_DOMAIN")}>",
      "Reply-To" =>
        "<announcement-#{announcement.id}@#{Constable.Env.get("INBOUND_EMAIL_DOMAIN")}>"
    }

    assert email.to == users
    assert email.subject == subject
    assert email.from == {from_name, from_email}
    assert email.headers == headers
    assert email.private.message_params.merge_language == "handlebars"

    assert email.private.message_params.merge_vars == [
             %{
               rcpt: user.email,
               vars: [
                 %{
                   name: "subscription_id",
                   content: subscription.token
                 }
               ]
             }
           ]

    html_comment_body = Constable.Markdown.to_html(comment.body)
    assert email.html_body =~ html_comment_body
    assert email.html_body =~ author.name
    assert email.html_body =~ HubProfile.image_url(author)

    assert email.text_body =~ comment.body
  end

  test "new mention in a comment" do
    author = insert(:user)
    user = insert(:user)
    announcement = insert(:announcement, user: author)
    comment = insert(:comment, user: author, announcement: announcement)
    users = [author, user]

    email = Emails.new_comment_mention(comment, users)

    from_name = "#{author.name} (Constable)"
    from_email = "announcements@#{Constable.Env.get("OUTBOUND_EMAIL_DOMAIN")}"

    headers = %{
      "In-Reply-To" =>
        "<announcement-#{announcement.id}@#{Constable.Env.get("OUTBOUND_EMAIL_DOMAIN")}>",
      "Reply-To" =>
        "<announcement-#{announcement.id}@#{Constable.Env.get("INBOUND_EMAIL_DOMAIN")}>"
    }

    assert email.to == users
    assert email.subject =~ announcement.title
    assert email.from == {from_name, from_email}
    assert email.headers == headers

    html_comment_body = Constable.Markdown.to_html(comment.body)
    assert email.html_body =~ html_comment_body
    assert email.html_body =~ author.name
    assert email.html_body =~ HubProfile.image_url(author)

    assert email.text_body =~ comment.body
  end
end
