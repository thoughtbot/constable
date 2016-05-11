defmodule Constable.DailyDigestTest do
  use Constable.ModelCase, async: true
  use Bamboo.Test
  alias Constable.Emails
  alias Constable.DailyDigest

  test "doesn't send if there are no new records since the time" do
    _old_announcement = insert(:announcement, inserted_at: yesterday)
    _old_interest = insert(:interest, inserted_at: yesterday)
    users = [insert(:user)]

    DailyDigest.send_email(users, yesterday)

    assert_no_emails_sent
  end

  test "includes interests and announcements since the passed in time" do
    users = [insert(:user)]
    _old_interest = insert(:interest, inserted_at: yesterday)
    new_interest = insert(:interest, inserted_at: today)
    _old_announcement = insert(:announcement, inserted_at: yesterday)
    new_announcement = insert(:announcement, inserted_at: today)
      |> Repo.preload(:interests)

    DailyDigest.send_email(users, yesterday)

    assert_delivered_email Emails.daily_digest([new_interest], [new_announcement], users)
  end

  test "sends if there are only new announcements" do
    new_announcement = insert(:announcement, inserted_at: today) |> Repo.preload(:interests)
    _old_interest = insert(:interest, inserted_at: yesterday)
    users = [insert(:user)]

    DailyDigest.send_email(users, yesterday)

    assert_delivered_email Emails.daily_digest([], [new_announcement], users)
  end

  test "sends if there are only new interests" do
    _old_announcement = insert(:announcement, inserted_at: yesterday)
    new_interest = insert(:interest, inserted_at: today)
    users = [insert(:user)]

    DailyDigest.send_email(users, yesterday)

    assert_delivered_email Emails.daily_digest([new_interest], [], users)
  end

  def today do
    Constable.Time.now
  end

  def yesterday do
    Constable.Time.yesterday
  end
end
