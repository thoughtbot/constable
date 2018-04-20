defmodule Constable.Factory do
  use ExMachina.Ecto, repo: Constable.Repo

  def email_reply_message_factory do
    %{
      text: "My email reply",
      from_email: sequence(:email, &"test#{&1}@thoughtbot.com"),
      email: "constable-fakekey@thoughtbot.com"
    }
  end

  def email_reply_event_factory do
    %{
      event: "inbound",
      msg: build(:email_reply_message)
    }
  end

  def email_reply_webhook_factory do
    %{
      mandrill_events: [build(:email_reply_event)]
    }
  end

  def interest_factory do
    %Constable.Interest{
      name: sequence(:interest_name, &"interest-#{&1}")
    }
  end

  def user_factory do
    %Constable.User{
      username: "myusername",
      name: "Gumbo",
      email: sequence(:email, &"test#{&1}@thoughtbot.com"),
      daily_digest: true,
      auto_subscribe: false,
      token: sequence(:token, &"omgtokens#{&1}")
    }
  end

  def with_interest(user, interest \\ insert(:interest)) do
    insert(:user_interest, user: user, interest: interest).user
  end

  def with_subscription(user, announcement \\ insert(:announcement)) do
    insert(:subscription, user: user, announcement: announcement).user
  end

  def announcement_factory do
    title = sequence(:email, &"Post Title#{&1}")
    slug = Slugger.slugify_downcase(title)

    %Constable.Announcement{
      title: title,
      slug: slug,
      body: "Post Body",
      user: build(:user)
    }
  end

  def tag_with_interest(announcement, interest) do
    insert(:announcement_interest, announcement: announcement, interest:
    interest).announcement
  end

  def with_subscriber(announcement, user) do
    insert(:subscription, announcement: announcement, user: user)
    |> Map.fetch!(:announcement)
  end

  def announcement_params_factory do
    %{
      title: "Title",
      body: "Body",
      user_id: nil
    }
  end

  def announcement_interest_factory do
    %Constable.AnnouncementInterest{
      announcement: build(:announcement),
      interest: build(:interest)
    }
  end

  def comment_factory do
    %Constable.Comment{
      body: "Post Body",
      user: build(:user),
      announcement: build(:announcement)
    }
  end

  def subscription_factory do
    %Constable.Subscription{
      user: build(:user),
      announcement: build(:announcement),
      token: sequence(:token, &"omgtokens#{&1}")
    }
  end

  def user_interest_factory do
    %Constable.UserInterest{
      user: build(:user),
      interest: build(:interest)
    }
  end
end
