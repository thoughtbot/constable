defmodule Constable.DailyDigestTest do
  use Constable.ModelCase, async: false

  alias Constable.DailyDigest
  alias Bamboo.SentEmail
  alias Bamboo.Formatter

  setup do
    SentEmail.reset
    :ok
  end

  test "doesn't send if there are no new records since the time" do
    _old_announcement = create(:announcement, inserted_at: yesterday)
    _old_interest = create(:interest, inserted_at: yesterday)
    users = [create(:user)]

    DailyDigest.send_email(users, yesterday)

    assert SentEmail.all == []
  end

  test "includes interests and announcements since the passed in time" do
    users = [create(:user)]
    old_interest = create(:interest, inserted_at: yesterday)
    new_interest = create(:interest, inserted_at: today)
    old_announcement = create(:announcement, inserted_at: yesterday)
    new_announcement = create(:announcement, inserted_at: today)

    DailyDigest.send_email(users, yesterday)

    subject = "Daily Digest"
    from_name = "Constable (thoughtbot)"
    from_email = "constable@#{Constable.Env.get("OUTBOUND_EMAIL_DOMAIN")}"
    email = SentEmail.one
    assert email.to == Formatter.format_recipient(users)
    assert email.subject == subject
    assert email.from == %{name: from_name, address: from_email}

    email_html_body = email.html_body
    email_text_body = email.text_body
    assert email_html_body =~ new_interest.name
    assert email_text_body =~ new_interest.name
    assert email_html_body =~ new_announcement.title
    assert email_text_body =~ new_announcement.title
    refute email_html_body =~ old_interest.name
    refute email_text_body =~ old_interest.name
    refute email_html_body =~ old_announcement.title
    refute email_text_body =~ old_announcement.title
  end

  test "sends if there are only new announcements" do
    _new_announcement = create(:announcement, inserted_at: today)
    _old_interest = create(:interest, inserted_at: yesterday)
    users = [create(:user)]

    DailyDigest.send_email(users, yesterday)

    assert SentEmail.one
  end

  test "sends if there are only new interests" do
    Pact.override(self, :mailer, FakeMandrill)
    _old_announcement = create(:announcement, inserted_at: yesterday)
    _new_interest = create(:interest, inserted_at: today)
    users = [create(:user)]

    DailyDigest.send_email(users, yesterday)

    assert SentEmail.one
  end

  def today do
    Constable.Time.now
  end

  def yesterday do
    Constable.Time.yesterday
  end
end
