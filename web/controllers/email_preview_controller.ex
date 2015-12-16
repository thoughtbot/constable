defmodule Constable.EmailPreviewController do
  use Constable.Web, :controller

  import Constable.Factory
  alias Constable.Emails

  def show(conn, %{"email_name" => email_name}) do
    html(conn, email_body(email_name))
  end

  defp email_for(:new_announcement) do
    Emails.new_announcement(announcement, [])
  end

  defp email_for(:new_comment) do
    Emails.new_comment(build(:comment), [])
  end

  defp email_for(:new_comment_mention) do
    Emails.new_comment_mention(build(:comment), [])
  end

  defp email_for(:new_announcement_mention) do
    Emails.new_announcement_mention(announcement, [])
  end

  defp email_for(:daily_digest) do
    Emails.daily_digest(
      build_pair(:interest),
      build_pair(:announcement),
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
    build(:announcement) |> Map.put(:interests, build_pair(:interest))
  end

  defp email_body(email_name) do
    email_for(String.to_atom(email_name)).html_body
  end
end
