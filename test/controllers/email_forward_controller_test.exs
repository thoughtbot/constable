defmodule ConstableWeb.EmailForwardControllerTest do
  use ConstableWeb.ConnCase, async: true
  use Bamboo.Test
  alias ConstableWeb.Endpoint
  alias Constable.Emails

  test "forwards email to admins" do
    System.put_env("ADMIN_EMAILS", "1@foo.com, 2@foo.com")
    forwarded_emails = create_email_forward_webhook(
      from_email: "someone@gmail.com",
      text: "YO DAWG",
      email: "admin@constable.io"
    )
    conn = build_conn()

    conn = post(conn, email_forward_path(Endpoint, :create), forwarded_emails)

    assert conn.status == 200
    message = forwarded_emails.mandrill_events |> Poison.decode! |> List.first |> Map.fetch!("msg")
    assert Emails.forwarded_email(message).to == ~w(1@foo.com 2@foo.com)
    assert_delivered_email Emails.forwarded_email(message)
  end

  defp create_email_forward_webhook(message_attributes) do
    email_reply_message = build(:email_reply_message, message_attributes)

    reply_events =
      build(:email_reply_event, msg: email_reply_message)
      |> List.wrap
      |> Poison.encode!
    build(:email_reply_webhook, mandrill_events: reply_events)
  end
end
