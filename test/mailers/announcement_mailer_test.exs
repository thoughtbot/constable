defmodule Constable.Mailers.AnnouncementTest do
  use Constable.TestWithEcto, async: false
  alias Constable.Mailers
  alias Constable.Repo
  alias Constable.Mandrill

  defmodule FakeMandrill do
    def message_send(message_params) do
      send self, {:to, message_params.to}
      send self, {:subject, message_params.subject}
      send self, {:from_email, message_params.from_email}
      send self, {:from_name, message_params.from_name}
      send self, {:html, message_params.html}
    end
  end

  test "sends announcement created email to people subscribed to the interest" do
    Pact.override(self, :mailer, FakeMandrill)
    interest = Forge.saved_interest(Repo)
    interested_users = [create_interested_user(interest)]
    announcement = create_announcement_with_interest(interest)

    Mailers.Announcement.created(announcement)

    author = announcement.user
    users = Mandrill.format_users(interested_users)
    subject = "#{announcement.title}"
    from_name = "#{author.name} (Constable)"
    from_email = "constable-#{announcement.id}@#{System.get_env("EMAIL_DOMAIN")}"
    assert_received {:to, ^users}
    assert_received {:subject, ^subject}
    assert_received {:from_email, ^from_email}
    assert_received {:from_name, ^from_name}
    assert_received {:html, email_body}
    assert String.contains?(email_body, announcement.title)
    assert String.contains?(email_body, announcement.body)
    assert String.contains?(email_body, author.name)
    assert String.contains?(email_body, Exgravatar.generate(author.email))
  end

  def create_announcement_with_interest(interest) do
    author = Forge.saved_user(Repo)
    Forge.saved_announcement(Repo, user_id: author.id)
    |> associate_interest_with_announcement(interest)
    |> Repo.preload([:user, :interested_users])
  end

  def create_interested_user(interest) do
    user = Forge.saved_user(Repo)
    Forge.saved_user_interest(Repo,
      interest_id: interest.id,
      user_id: user.id
    )
    user
  end

  def associate_interest_with_announcement(announcement, interest) do
    Forge.saved_announcement_interest(
      Repo, announcement_id: announcement.id, interest_id: interest.id
    )
    announcement
  end
end
