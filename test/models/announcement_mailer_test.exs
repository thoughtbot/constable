defmodule ConstableApi.Mailers.AnnouncementTest do
  use ConstableApi.TestWithEcto, async: false
  alias ConstableApi.Mailers
  alias ConstableApi.Repo
  alias ConstableApi.Mandrill

  defmodule FakeMandrill do
    def message_send(message_params) do
      send self, {:to, message_params.to}
      send self, {:subject, message_params.subject}
      send self, {:from_email, message_params.from_email}
      send self, {:from_name, message_params.from_name}
      send self, {:text, message_params.text}
    end
  end

  test "sends announcement created email" do
    Pact.override(self, :mailer, FakeMandrill)
    author = Forge.saved_user(Repo)
    users = [author, Forge.saved_user(Repo)]
    title = "Foo Announcement"
    subject = "#{title}"
    body = "Bar is cool"
    announcement = Forge.announcement(title: title, body: body, user: author)

    Mailers.Announcement.created(announcement)

    users = Mandrill.format_users(users)
    assert_received {:to, ^users}
    assert_received {:subject, ^subject}
    assert_received {:from_name, "Constable Announcement"}
    assert_received {:text, body}
    assert String.contains?(body, title)
    assert String.contains?(body, body)
    assert String.contains?(body, author.email)
  end
end
