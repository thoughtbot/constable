defmodule Constable.EmailsTest do
  use ConstableWeb.ConnCase, async: true

  import Constable.Factory
  import Phoenix.HTML, only: [safe_to_string: 1]
  import Phoenix.HTML.Link

  test "daily_digest" do
    users = insert_pair(:user)
    interests = insert_pair(:interest)
    [comment_1, comment_2] = insert_pair(:comment, announcement: insert(:announcement))
    comment_3 = insert(:comment, announcement: insert(:announcement))
    comments = [comment_1, comment_2, comment_3]
    announcements = [insert_announcement_with_interests(), insert_announcement_with_interests()]

    email = Constable.Emails.daily_digest(interests, announcements, comments, users)

    assert email.subject == "Daily Digest"
    assert email.to == users

    assert email.from == {
             "Constable (thoughtbot)",
             "constable@#{Constable.Env.get("OUTBOUND_EMAIL_DOMAIN")}"
           }

    for interest <- interests do
      assert both_parts_contain(email, interest.name)
    end

    for announcement <- announcements do
      assert email |> both_parts_contain(announcement.title)
      assert email |> both_parts_contain(announcement.body)
      assert email.html_body =~ posted_by_html(announcement.user.name, announcement)
      assert email.text_body =~ posted_by_text(announcement.user.name, announcement)
    end

    for comment <- comments do
      assert email |> both_parts_contain(comment.user.name)
      assert email |> both_parts_contain(comment.body)
    end
  end

  defp both_parts_contain(email, string) do
    email.html_body =~ string && email.text_body =~ string
  end

  defp insert_announcement_with_interests do
    insert(:announcement)
    |> tag_with_interest(insert(:interest))
    |> tag_with_interest(insert(:interest))
    |> Repo.preload(:interests)
  end

  defp posted_by_html(username, announcement) do
    "posted by <strong>#{username}</strong> in #{interest_links(announcement)}"
  end

  defp posted_by_text(username, announcement) do
    "posted by #{username} in #{interest_names(announcement)}"
  end

  defp interest_names(announcement) do
    announcement
    |> Map.get(:interests)
    |> Enum.map(&"#{&1.name}")
    |> Enum.join(", ")
  end

  def interest_links(announcement) do
    announcement
    |> Map.get(:interests)
    |> Enum.map(&make_link/1)
    |> Enum.join(", ")
  end

  defp make_link(interest) do
    "#{interest.name}"
    |> link(
      to: Routes.interest_url(ConstableWeb.Endpoint, :show, interest),
      style: "color: #aeaeae;"
    )
    |> safe_to_string
  end
end
