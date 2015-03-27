defmodule Constable.EmailReplyController do
  use Constable.Web, :controller
  alias Constable.Comment
  alias Constable.Queries

  plug :action

  def create(conn, %{"msg" => message}) do
    Comment.changeset(:create, comment_params(message))
    |> Repo.insert

    conn |> put_status(:created)
  end

  defp comment_params(message) do
    %{"text" => email_body, "email" => to, "from_email" => from} =  message
    announcement_id = announcement_id_from_email_address(to)
    user = Queries.User.with_email(from) |> Repo.one
    %{user_id: user.id, announcement_id: announcement_id, body: email_body}
  end

  defp announcement_id_from_email_address("constable-" <> key_and_domain) do
    key_and_domain |> String.split("@") |> List.first
  end
end
