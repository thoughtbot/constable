defmodule Constable.Mailers.AnnouncementTest do
  use Constable.TestWithEcto, async: false

  alias Constable.Mailers
  alias Constable.Mandrill

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

  test "sends markdown formatted email to people subscribed to the interest" do
    Pact.override(self, :mailer, FakeMandrill)
    interest = create(:interest)
    interest_2 = create(:interest)
    interested_users = [create_interested_user(interest)]
    announcement = create_announcement_with_interests([interest, interest_2])

    Mailers.Announcement.created(announcement, interested_users)

    author = announcement.user
    users = Mandrill.format_users(interested_users)
    subject = "#{announcement.title}"
    from_name = "#{author.name} (Constable)"
    from_email = "constable-#{announcement.id}@#{System.get_env("EMAIL_DOMAIN")}"
    assert_received {:to, ^users}
    assert_received {:subject, ^subject}
    assert_received {:from_email, ^from_email}
    assert_received {:from_name, ^from_name}
    assert_received {:html, email_html_body}
    assert_received {:text, email_text_body}
    html_announcement_body = Earmark.to_html(announcement.body)

    assert email_html_body =~ html_announcement_body
    assert email_html_body =~ "##{interest.name}, ##{interest_2.name}"
    assert email_html_body =~ author.name
    assert email_html_body =~ Exgravatar.generate(author.email)

    assert email_text_body =~ announcement.title
    assert email_text_body =~ "Announced by: #{author.name}"
    assert email_text_body =~ announcement.body
  end

  def create_announcement_with_interests(interests) do
    create(:announcement)
    |> associate_interests_with_announcement(interests)
    |> Repo.preload([:user, :interested_users])
  end

  def create_interested_user(interest) do
    user = create(:user)
    create(:user_interest, interest: interest, user: user)
    user
  end

  def associate_interests_with_announcement(announcement, interests) do
    Enum.each(interests, fn(interest) ->
      create(:announcement_interest, announcement: announcement, interest: interest)
    end)
    announcement
  end
end
