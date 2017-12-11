defmodule ConstableWeb.EmailReplyTest do
  use ConstableWeb.ConnCase, async: true
  use Bamboo.Test
  alias Constable.Emails
  alias Constable.Comment

  test "adds a comment to announcement and sends an email" do
    subscriber = insert(:user)
    announcement = insert(:announcement) |> with_subscriber(subscriber)
    comment_author = insert(:user)
    conn = build_conn()

    email_reply_webhook = create_email_reply_webhook(
      from_email: comment_author.email,
      text: "YO DAWG",
      email: "announcement-#{announcement.id}@foo.com"
    )

    conn = post(conn, "/email_replies", email_reply_webhook)

    comment = Repo.one(Comment) |> Repo.preload([:user, announcement: :user])
    assert conn.status == 200
    assert comment.announcement_id == announcement.id
    assert comment.user_id == comment_author.id
    assert comment.body == "YO DAWG"

    assert_delivered_email Emails.new_comment(comment, [subscriber])
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
    comment_author = insert(:user)
    announcement = insert(:announcement)
    email_reply_webhook = create_email_reply_webhook(
      from_email: comment_author.email,
      text: whole_email_with_quoted_text,
      email: "announcement-#{announcement.id}@foo.com"
    )
    conn = build_conn()

    post(conn, "/email_replies", email_reply_webhook)

    comment = Repo.one(Comment)
    assert comment.body == String.strip(user_text)
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
