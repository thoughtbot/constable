defmodule ConstableWeb.EmailPreviewController do
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
    Emails.new_announcement(insert_announcement_with_interests(), [])
  end

  defp email_for(:new_comment) do
    Emails.new_comment(insert(:comment), [])
  end

  defp email_for(:new_comment_mention) do
    Emails.new_comment_mention(insert(:comment), [])
  end

  defp email_for(:new_announcement_mention) do
    Emails.new_announcement_mention(insert_announcement_with_interests(), [])
  end

  defp email_for(:daily_digest) do
    announcement_with_comments = insert_announcement_with_interests()
    other_announcement_with_comments = insert_announcement_with_interests()
    user_1 = insert(:user, name: "User 1")
    user_2 = insert(:user, name: "User 2")

    Emails.daily_digest(
      insert_pair(:interest),
      [insert_announcement_with_interests(), insert_announcement_with_interests()],
      [
        insert(:comment, user: user_1, announcement: announcement_with_comments),
        insert(:comment, user: user_2, announcement: announcement_with_comments),
        insert(:comment, user: user_2, announcement: announcement_with_comments),
        insert(:comment, user: user_1, announcement: other_announcement_with_comments),
        insert(:comment, user: user_2, announcement: other_announcement_with_comments),
        insert(:comment, user: user_2, announcement: other_announcement_with_comments),
      ],
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

  defp insert_announcement_with_interests do
    insert(:announcement)
    |> tag_with_interest(insert(:interest))
    |> tag_with_interest(insert(:interest))
    |> Repo.preload(:interests)
  end
end
