defmodule Constable.Mailers.AnnouncementTest do
  use Constable.TestWithEcto, async: false
  alias Constable.Emails

  test "sends markdown formatted email to people subscribed to the interest" do
    interest = insert(:interest)
    interest_2 = insert(:interest)
    interested_users = [create_interested_user(interest)]
    announcement = create_announcement_with_interests([interest, interest_2])

    email = Emails.new_announcement(announcement, interested_users)

    author = announcement.user
    from_name = "#{author.name} (Constable)"
    from_email = "announcements@#{Constable.Env.get("OUTBOUND_EMAIL_DOMAIN")}"
    headers = %{
      "Message-ID" => "<announcement-#{announcement.id}@#{Constable.Env.get("OUTBOUND_EMAIL_DOMAIN")}>",
      "Reply-To" => "<announcement-#{announcement.id}@#{Constable.Env.get("INBOUND_EMAIL_DOMAIN")}>",
      "List-Unsubscribe" => Constable.EmailView.unsubscribe_link
    }
    html_announcement_body = Earmark.to_html(announcement.body)
    assert email.to == interested_users
    assert email.subject == announcement.title
    assert email.from == {from_name, from_email}
    assert email.headers == headers
    assert email.html_body =~ html_announcement_body
    assert email.html_body =~ author.name
    assert email.html_body =~ Exgravatar.generate(author.email)
    assert email.html_body =~ interest.name
    assert email.html_body =~ interest_2.name
    assert email.text_body =~ announcement.body
  end

  def create_announcement_with_interests(interests) do
    insert(:announcement)
    |> associate_interests_with_announcement(interests)
    |> Repo.preload([:user, interests: :interested_users])
  end

  def create_interested_user(interest) do
    user = insert(:user)
    insert(:user_interest, interest: interest, user: user)
    user
  end

  def associate_interests_with_announcement(announcement, interests) do
    Enum.each(interests, fn(interest) ->
      insert(:announcement_interest, announcement: announcement, interest: interest)
    end)
    announcement
  end
end
