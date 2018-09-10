defmodule ConstableWeb.EmailForwardController do
  use Constable.Web, :controller

  def create(conn, %{"mandrill_events" => messages}) do
    messages
    |> Poison.decode!
    |> forward_emails_to_admins

    text(conn, nil)
  end

  defp forward_emails_to_admins(forwarded_emails) do
    for %{"msg" => message} <- forwarded_emails do
      message
      |> Constable.Emails.forwarded_email
      |> Constable.Mailer.deliver_now
    end
  end
end
