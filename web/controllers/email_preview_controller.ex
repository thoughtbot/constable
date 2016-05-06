defmodule Constable.EmailPreviewController do
  use Constable.Web, :controller

  import Constable.Factory
  alias Constable.Emails

  def show(conn, %{"email_name" => email_name}) do
    {:error, body} = Repo.transaction fn ->
      email_body(email_name) |> Repo.rollback
    end

    html(conn, body)
  end

  defp email_body(email_name) do
    email_for(String.to_atom(email_name)).html_body
  end

  defp email_for(:new_announcement) do
    Emails.new_announcement(announcement, [])
  end

  defp email_for(:new_comment) do
    Emails.new_comment(insert(:comment), [])
  end

  defp email_for(:new_comment_mention) do
    Emails.new_comment_mention(insert(:comment), [])
  end

  defp email_for(:new_announcement_mention) do
    Emails.new_announcement_mention(announcement, [])
  end

  defp email_for(:daily_digest) do
    Emails.daily_digest(
      insert_pair(:interest),
      insert_pair(:announcement),
      []
    )
  end

  defp email_for(email_name) do
    %{
      html_body: """
      <h1>There is no email preview for #{inspect email_name}</h1>
      <p>
        Add one to #{inspect __MODULE__}
      </p>
      """
    }
  end

  defp announcement do
    insert(:announcement, interests: insert_pair(:interest))
  end
end
