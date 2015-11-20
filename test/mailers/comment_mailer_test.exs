defmodule Constable.Mailers.CommentMailerTest do
  use Constable.TestWithEcto, async: false

  alias Constable.Emails

  test "new comment email" do
    author = create(:user)
    user = create(:user)
    announcement = create(:announcement, user: author)
    comment = create(:comment, user: author, announcement: announcement)
    users = [author, user]

    email = Emails.new_comment(comment, users)

    subject = "Re: #{announcement.title}"
    from_name = "#{author.name} (Constable)"
    from_email = "announcements@#{Constable.Env.get("OUTBOUND_EMAIL_DOMAIN")}"
    headers = %{
      "In-Reply-To" => "<announcement-#{announcement.id}@#{Constable.Env.get("OUTBOUND_EMAIL_DOMAIN")}>",
      "Reply-To" => "<announcement-#{announcement.id}@#{Constable.Env.get("INBOUND_EMAIL_DOMAIN")}>"
    }
    assert email.to == users
    assert email.subject == subject
    assert email.from == %{name: from_name, address: from_email}
    assert email.headers == headers

    html_comment_body = Earmark.to_html(comment.body)
    assert email.html_body =~ announcement.title
    assert email.html_body =~ html_comment_body
    assert email.html_body =~ author.name
    assert email.html_body =~ Exgravatar.generate(author.email)

    assert email.text_body =~ comment.body
  end

  test "new mention in a comment" do
    author = create(:user)
    user = create(:user)
    announcement = create(:announcement, user: author)
    comment = create(:comment, user: author, announcement: announcement)
    users = [author, user]

    email = Emails.new_comment_mention(comment, users)

    from_name = "#{author.name} (Constable)"
    from_email = "announcements@#{Constable.Env.get("OUTBOUND_EMAIL_DOMAIN")}"
    headers = %{
      "In-Reply-To" => "<announcement-#{announcement.id}@#{Constable.Env.get("OUTBOUND_EMAIL_DOMAIN")}>",
      "Reply-To" => "<announcement-#{announcement.id}@#{Constable.Env.get("INBOUND_EMAIL_DOMAIN")}>"
    }
    assert email.to == users
    assert email.subject =~ announcement.title
    assert email.from == %{name: from_name, address: from_email}
    assert email.headers == headers

    html_comment_body = Earmark.to_html(comment.body)
    assert email.html_body =~ announcement.title
    assert email.html_body =~ html_comment_body
    assert email.html_body =~ author.name
    assert email.html_body =~ Exgravatar.generate(author.email)

    assert email.text_body =~ comment.body
  end
end
