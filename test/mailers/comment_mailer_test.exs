defmodule Constable.Mailers.CommentMailerTest do
  use Constable.TestWithEcto, async: false

  alias Constable.Mailers
  alias Constable.Mandrill

  defmodule FakeMandrill do
    def message_send(message_params) do
      send self, {:to, message_params.to}
      send self, {:subject, message_params.subject}
      send self, {:from_email, message_params.from_email}
      send self, {:headers, message_params.headers}
      send self, {:from_name, message_params.from_name}
      send self, {:html, message_params.html}
      send self, {:text, message_params.text}
    end
  end

  test "sends markdown formatted new comment email" do
    Pact.override(self, :mailer, FakeMandrill)
    author = create(:user)
    user = create(:user)
    users = [author, user]
    title = "Foo Announcement"
    subject = "Re: #{title}"
    comment_body = "Bar is cool"
    from_name = "#{author.name} (Constable)"
    announcement = create(:announcement, title: title, user: author)
    from_email = "announcements@#{Constable.Env.get("OUTBOUND_EMAIL_DOMAIN")}"
    headers = %{
      "Reply-To": "announcement-#{announcement.id}@#{Constable.Env.get("INBOUND_EMAIL_DOMAIN")}"
    }
    create(:subscription, user: author, announcement: announcement)
    comment = create(:comment,
      body: comment_body,
      user: author,
      announcement: announcement
    )

    Mailers.Comment.created(comment, users)

    users = Mandrill.format_users(users)
    assert_received {:to, ^users}
    assert_received {:subject, ^subject}
    assert_received {:from_name, ^from_name}
    assert_received {:from_email, ^from_email}
    assert_received {:headers, ^headers}
    assert_received {:html, email_html_body}
    assert_received {:text, email_text_body}
    html_comment_body = Earmark.to_html(comment.body)

    assert email_html_body =~ title
    assert email_html_body =~ html_comment_body
    assert email_html_body =~ author.name
    assert email_html_body =~ Exgravatar.generate(author.email)

    assert email_text_body =~ "#{author.name} commented on #{announcement.title}"
    assert email_text_body =~ comment.body
  end
end
