defmodule Constable.DailyDigestTest do
  use Constable.ModelCase, async: false
  require Forge
  alias Constable.Repo
  alias Constable.Mandrill
  alias Constable.DailyDigest

  defmodule FakeMandrill do
    def message_send(message_params) do
      send self, {:to, message_params.to}
      send self, {:subject, message_params.subject}
      send self, {:from_email, message_params.from_email}
      send self, {:from_name, message_params.from_name}
      send self, {:html, message_params.html}
      send self, {:text, message_params.text}
    end
  end

  test "does not send email if there are no new announcements" do
    Repo.delete_all(Constable.Announcement)
    Pact.override(self, :mailer, FakeMandrill)
    Forge.saved_user(Repo)
    users = [Forge.saved_user(Repo)]

    DailyDigest.send_email(users)

    refute_receive {:to, _}
  end

  test "includes interests and announcements from the last 24 hours" do
    Pact.override(self, :mailer, FakeMandrill)
    author = Forge.saved_user(Repo)
    users = [Forge.saved_user(Repo)]
    old_interest = Forge.saved_interest(Repo, inserted_at: yesterday)
    new_interest = Forge.saved_interest(Repo, inserted_at: today)
    Forge.having(user_id: author.id) do
      old_announcement = Forge.saved_announcement(Repo, inserted_at: yesterday)
      new_announcement = Forge.saved_announcement(Repo, inserted_at: today)
    end

    DailyDigest.send_email(users)

    subject = "Daily Digest"
    from_name = "Constable (thoughtbot)"
    from_email = "constable@#{System.get_env("EMAIL_DOMAIN")}"
    users = Mandrill.format_users(users)
    assert_receive {:to, ^users}
    assert_receive {:subject, ^subject}
    assert_receive {:from_name, ^from_name}
    assert_receive {:from_email, ^from_email}
    assert_receive {:html, email_html_body}
    assert_receive {:text, email_text_body}

    assert email_html_body =~ new_interest.name
    assert email_text_body =~ new_interest.name
    assert email_html_body =~ new_announcement.title
    assert email_text_body =~ new_announcement.title
    refute email_html_body =~ old_interest.name
    refute email_text_body =~ old_interest.name
    refute email_html_body =~ old_announcement.title
    refute email_text_body =~ old_announcement.title
  end

  def today do
    Constable.Time.now
  end

  def yesterday do
    Constable.Time.yesterday
  end
end
