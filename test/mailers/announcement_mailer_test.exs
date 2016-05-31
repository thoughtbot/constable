defmodule Constable.Mailers.AnnouncementTest do
  use Constable.TestWithEcto, async: false
  import Constable.Router.Helpers
  import Constable.EmailHelper
  alias Constable.Emails

  test "sends a correctly formatted email to a list of users" do
    [interest_1, interest_2] = insert_pair(:interest)
    [user_1, user_2] = insert_pair(:user)
    announcement = insert(:announcement)
      |> tag_with_interest(interest_1)
      |> tag_with_interest(interest_2)
      |> with_subscriber(user_1)
      |> with_subscriber(user_2)
      |> Repo.preload(:interests)

    email = Emails.new_announcement(announcement, [user_1, user_2])

    author = announcement.user
    from_name = "#{author.name} (Constable)"
    from_email = "announcements@#{Constable.Env.get("OUTBOUND_EMAIL_DOMAIN")}"
    headers = %{
      "Message-ID" => "<announcement-#{announcement.id}@#{Constable.Env.get("OUTBOUND_EMAIL_DOMAIN")}>",
      "Reply-To" => "<announcement-#{announcement.id}@#{Constable.Env.get("INBOUND_EMAIL_DOMAIN")}>",
      "List-Unsubscribe" => Constable.EmailView.unsubscribe_link
    }
    html_announcement_body = Earmark.to_html(announcement.body)
    assert email.to == [user_1, user_2]
    assert email.subject == announcement.title
    assert email.from == {from_name, from_email}
    assert email.headers == headers
    assert email.html_body =~ html_announcement_body
    assert email.html_body =~ author.name
    assert email.html_body =~ Exgravatar.generate(author.email)
    assert email.html_body =~ interest_1.name
    assert email.html_body =~ interest_2.name
    assert email.text_body =~ announcement.body
    assert email_contains_interest_link(email, interest_1)
    assert email_contains_interest_link(email, interest_2)
    assert email.text_body =~ interest_1.name
    assert email.text_body =~ interest_2.name
    assert email.private.message_params.merge_language == "handlebars"
    assert email.private.message_params.merge_vars == [
      merge_vars_for(user_1, announcement),
      merge_vars_for(user_2, announcement)
    ]
  end

  test "new_announcement_mention" do
    users = build_pair(:user)
    announcement = insert(:announcement)

    email = Constable.Emails.new_announcement_mention(announcement, users)

    assert email.to == users
    assert email.from == {
      "#{announcement.user.name} (Constable)",
      "announcements@#{Constable.Env.get("OUTBOUND_EMAIL_DOMAIN")}"
    }
  end

  defp email_contains_interest_link(email, interest) do
    interest_link = interest_url(Constable.Endpoint, :show, interest)
    email.html_body =~ ~s(a href="#{interest_link}")
  end
end
