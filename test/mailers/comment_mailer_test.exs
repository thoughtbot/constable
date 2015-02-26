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
      send self, {:text, message_params.text}
    end
  end

  test "sends announcement created email" do
    Pact.override(self, :mailer, FakeMandrill)
    author = Forge.saved_user(Repo)
    users = [author, Forge.saved_user(Repo)]
    title = "Foo Announcement"
    subject = "#{title}"
    comment_body = "Bar is cool"
    from_name = "#{author.name} (Constable)"
    announcement = Forge.saved_announcement(Repo, title: title, user_id: author.id)
    comment = Forge.comment(
      body: comment_body,
      user: author,
      announcement: announcement
    )

    Mailers.Comment.created(comment, users)

    # users = Mandrill.format_users(users)
    # assert_received {:to, ^users}
    # assert_received {:subject, ^subject}
    # assert_received {:from_name, from_name}
    # assert_received {:text, body}
    # assert String.contains?(body, title)
    # assert String.contains?(body, comment_body)
    # assert String.contains?(body, author.email)
  end
end
