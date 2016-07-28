defmodule Constable.Mailers.AnnouncementTest do
  use Constable.TestWithEcto, async: false
  import Constable.Router.Helpers
  alias Constable.Emails

  defmodule FakeSubscriptionToken do
    def encode(_subscription), do: "fake_subscription_token"
  end

  test "sends a correctly formatted email to a list of users" do
    Pact.override(self, :subscription_token, FakeSubscriptionToken)

    author = insert(:user)
    user = insert(:user)
    users = [author, user]

    [interest_1, interest_2] = insert_pair(:interest)
    announcement = insert(:announcement, user: author)
      |> tag_with_interest(interest_1)
      |> tag_with_interest(interest_2)
      |> Repo.preload(:interests)

    insert(:subscription, user: user, announcement: announcement)

    email = Emails.new_announcement(announcement, users)

    from_name = "#{author.name} (Constable)"
    from_email = "announcements@#{Constable.Env.get("OUTBOUND_EMAIL_DOMAIN")}"
    headers = %{
      "Message-ID" => "<announcement-#{announcement.id}@#{Constable.Env.get("OUTBOUND_EMAIL_DOMAIN")}>",
      "Reply-To" => "<announcement-#{announcement.id}@#{Constable.Env.get("INBOUND_EMAIL_DOMAIN")}>",
    }
    html_announcement_body = Earmark.to_html(announcement.body)
    assert email.to == users
    assert email.subject == announcement.title
    assert email.from == {from_name, from_email}
    assert email.headers == headers
    assert email.private.message_params.merge_language == "handlebars"
    assert email.private.message_params.merge_vars == [
      %{
        rcpt: user.email,
        vars: [
          %{
            name: "subscription_id",
            content: "fake_subscription_token"
          }
        ]
      }
    ]
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
