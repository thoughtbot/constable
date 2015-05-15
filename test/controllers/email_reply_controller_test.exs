defmodule Constable.EmailReplyTest do
  use Constable.ConnCase
  alias Constable.Comment

  test "adds a comment to announcement from the message key" do
    user = Forge.saved_user(Repo)
    announcement = Forge.saved_announcement(Repo, user_id: user.id)
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
    email_reply_message = Forge.email_reply_message(message_attributes)
    Forge.email_reply_webhook(msg: email_reply_message)
  end
end
