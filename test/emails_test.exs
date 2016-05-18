defmodule Constable.EmailsTest do
  use Constable.ConnCase, async: true
  import Constable.Factory

  test "daily_digest" do
    users = insert_pair(:user)
    interests = insert_pair(:interest)
    announcements = [insert_announcement_with_interests, insert_announcement_with_interests]

    email = Constable.Emails.daily_digest(interests, announcements, [], users)

    assert email.subject == "Daily Digest"
    assert email.to == users
    assert email.from == {
      "Constable (thoughtbot)",
      "constable@#{Constable.Env.get("OUTBOUND_EMAIL_DOMAIN")}"
    }
    for interest <- interests do
      assert email.html_body =~ interest.name
      assert email.text_body =~ interest.name
    end
    for announcement <- announcements do
      assert email.html_body =~ announcement.title
      assert email.text_body =~ announcement.title
      assert email.html_body =~ posted_by_html(announcement.user.name, announcement)
      assert email.text_body =~ posted_by_text(announcement.user.name, announcement)
    end
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
    |> Enum.map(&("##{&1.name}"))
    |> Enum.join(", ")
  end

  def interest_links(announcement) do
    announcement
    |> Map.get(:interests)
    |> Enum.map(&make_link/1)
    |> Enum.join(", ")
  end

  defp make_link(interest) do
    "##{interest.name}"
    |> link(to: interest_url(Constable.Endpoint, :show, interest), style: "color: #aeaeae;")
    |> safe_to_string
  end
end
