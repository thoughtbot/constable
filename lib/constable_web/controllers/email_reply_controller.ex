defmodule ConstableWeb.EmailReplyController do
  use Constable.Web, :controller
  alias Constable.Services.CommentCreator
  alias Constable.User
  alias Constable.EmailReplyParser

  def create(conn, %{"mandrill_events" => messages}) do
    messages
    |> Poison.decode!
    |> create_comments

    text(conn, nil)
  end

  defp create_comments(messages) do
    for message <- messages do
      message |> comment_params |> CommentCreator.create
    end
  end

  defp comment_params(
    %{"msg" => %{"text" => email_body, "email" => to, "from_email" => from}}) do
    %{
      user_id: user_from_email(from).id,
      announcement_id: announcement_id_from_email(to),
      body: EmailReplyParser.remove_original_email(email_body)
    }
  end

  defp user_from_email(email_address) do
    User.with_email(email_address) |> Repo.one
  end

  defp announcement_id_from_email("announcement-" <> key_and_domain) do
    key_and_domain |> String.split("@") |> List.first
  end
end
