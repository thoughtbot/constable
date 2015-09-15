defmodule Constable.EmailReplyTest do
  use Constable.ConnCase

  alias Constable.Comment

  test "adds a comment to announcement from the message key" do
    user = create(:user)
    announcement = create(:announcement, user: user)
    email_reply_webhook = create_email_reply_webhook(
      from_email: user.email,
      text: "YO DAWG",
      email: "constable-#{announcement.id}@thoughtbot.com"
    )

    post conn, "/email_replies", email_reply_webhook

    comment = Repo.one(Comment)
    assert comment.announcement_id == announcement.id
    assert comment.user_id == user.id
    assert comment.body == "YO DAWG"
  end

  defp create_email_reply_webhook(message_attributes) do
    email_reply_message = build(:email_reply_message, message_attributes)
    build(:email_reply_webhook, msg: email_reply_message)
  end
end
