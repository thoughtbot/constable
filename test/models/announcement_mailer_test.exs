defmodule Constable.Mailers.AnnouncementTest do
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
      send self, {:text, message_params.text}
    end
  end

  test "sends announcement created email to people subscribed to the interest" do
    Pact.override(self, :mailer, FakeMandrill)
    author = Forge.saved_user(Repo)
    users = [author, Forge.saved_user(Repo)]
    title = "Foo Announcement"
    subject = "#{title}"
    body = "Bar is cool"
    from_name = "#{author.name} (Constable)"
    announcement = Forge.announcement(title: title, body: body, user: author)

    Mailers.Announcement.created(announcement)

    users = Mandrill.format_users(users)
    assert_received {:to, ^users}
    assert_received {:subject, ^subject}
    assert_received {:from_name, ^from_name}
    assert_received {:text, email_body}
    assert String.contains?(email_body, title)
    assert String.contains?(email_body, body)
    assert String.contains?(email_body, author.name)
  end
end
