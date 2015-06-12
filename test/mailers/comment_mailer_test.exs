defmodule Constable.Mailers.CommentMailerTest do
  use Constable.TestWithEcto, async: false
  alias Constable.Mailers
  alias Constable.Repo
  alias Constable.Mandrill

  defmodule FakeMandrill do
    def message_send(message_params) do
      send self, {:to, message_params.to}
      send self, {:subject, message_params.subject}
      send self, {:from_email, message_params.from_email}
      send self, {:from_name, message_params.from_name}
      send self, {:html, message_params.html}
    end
  end

  test "sends markdown formatted new comment email" do
    Pact.override(self, :mailer, FakeMandrill)
    author = Forge.saved_user(Repo)
    users = [author, Forge.saved_user(Repo)]
    title = "Foo Announcement"
    subject = "Re: #{title}"
    comment_body = "Bar is cool"
    from_name = "#{author.name} (Constable)"
    announcement = Forge.saved_announcement(Repo, title: title, user_id: author.id)
    from_email = "constable-#{announcement.id}@#{System.get_env("EMAIL_DOMAIN")}"
    comment = Forge.comment(
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
    assert_received {:html, body}
    html_comment_body = Earmark.to_html(comment.body)
    assert String.contains?(body, title)
    assert String.contains?(body, html_comment_body)
    assert String.contains?(body, author.name)
    assert String.contains?(body, Exgravatar.generate(author.email))
  end
end
