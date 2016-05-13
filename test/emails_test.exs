defmodule Constable.EmailsTest do
  use Constable.ConnCase, async: true
  import Constable.Factory

  test "daily_digest" do
    users = insert_pair(:user)
    interests = insert_pair(:interest)
    announcements = insert_pair(:announcement) |> Repo.preload(:interests)

    email = Constable.Emails.daily_digest(interests, announcements, users)

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

      for interest <- announcement.interests do
        assert email.html_body =~ interest.name
        assert email.text_body =~ interest.name
      end
    end
  end
end
