defmodule Constable.EmailReplyTest do
  use Constable.ConnCase

  alias Constable.Comment

  defmodule FakeCommentMailer do
    def created(comment, users) do
      send self, {:comment, comment}
      send self, {:users, users}
    end

    def mentioned(_, _), do: nil
  end

  test "adds a comment to announcement and sends an email" do
    Pact.override self, :comment_mailer, FakeCommentMailer
    user = create(:user)
    announcement = create(:announcement, user: user)
    email_reply_webhook = create_email_reply_webhook(
      from_email: user.email,
      text: "YO DAWG",
      email: "announcement-#{announcement.id}@foo.com"
    )

    conn = post(conn, "/email_replies", email_reply_webhook)

    comment = Repo.one(Comment, preload: [:user, :announcement])
    assert conn.status == 200
    assert comment.announcement_id == announcement.id
    assert comment.user_id == user.id
    assert comment.body == "YO DAWG"

    assert_received {:comment, ^comment}
  end

  test "removes the last quoted section from the email reply" do
    user_text = """
    Text that I wrote

    > With a quote. Will it work?

    Sure looks like it!!
    """
    whole_email_with_quoted_text = """
    #{user_text}\n> On Oct 16, 2015, at 5:05 PM, Paul Smith (Constable) <constable-40@#{Constable.Env.get("OUTBOUND_EMAIL_DOMAIN")}> wrote:\n> \n> \t\n> my text\t\n\n\n
    """
    comment_author = create(:user)
    announcement = create(:announcement)
    email_reply_webhook = create_email_reply_webhook(
      from_email: comment_author.email,
      text: whole_email_with_quoted_text,
      email: "announcement-#{announcement.id}@foo.com"
    )

    post(conn, "/email_replies", email_reply_webhook)

    comment = Repo.one(Comment)
    assert comment.body == user_text
  end

  defp create_email_reply_webhook(message_attributes) do
    email_reply_message = build(:email_reply_message, message_attributes)

    reply_events =
      build(:email_reply_event, msg: email_reply_message)
      |> List.wrap
      |> Poison.encode!
    build(:email_reply_webhook, mandrill_events: reply_events)
  end
end
