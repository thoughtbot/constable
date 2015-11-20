defmodule Constable.Factories do
  use ExMachina.Ecto, repo: Constable.Repo

  def factory :email_reply_message do
    %{
      text: "My email reply",
      from_email: sequence(:email, &"test#{&1}@thoughtbot.com"),
      email: "constable-fakekey@thoughtbot.com"
    }
  end

  def factory :email_reply_event do
    %{
      event: "inbound",
      msg: build(:email_reply_message)
    }
  end

  def factory :email_reply_webhook do
    %{
      mandrill_events: [build(:email_reply_event)]
    }
  end

  def factory :interest do
    %Constable.Interest{
      name: sequence(:interest_name, &"interest-#{&1}")
    }
  end

  def factory :user do
    %Constable.User{
      username: "myusername",
      name: "Gumbo",
      email: sequence(:email, &"test#{&1}@thoughtbot.com"),
      daily_digest: true,
      auto_subscribe: false
    }
  end

  def factory :announcement do
    %Constable.Announcement{
      title: sequence(:email, &"Post Title#{&1}"),
      body: "Post Body",
      user: build(:user)
    }
  end

  def factory :announcement_params do
    %{
      title: "Title",
      body: "Body",
      user_id: nil
    }
  end

  def factory :announcement_interest do
    %Constable.AnnouncementInterest{
      announcement: build(:announcement),
      interest: build(:interest)
    }
  end

  def factory :comment do
    %Constable.Comment{
      body: "Post Body",
      user: build(:user),
      announcement: build(:announcement)
    }
  end

  def factory :subscription do
    %Constable.Subscription{
      user: build(:user),
      announcement: build(:announcement)
    }
  end

  def factory :user_interest do
    %Constable.UserInterest{
      user: build(:user),
      interest: build(:interest)
    }
  end

  def tag_with_interest(announcement, interest) do
    create(:announcement_interest, announcement: announcement, interest:
    interest).announcement
  end

  def with_comment(announcement) do
    create(:comment, announcement: announcement).announcement
  end

  def with_interest(user, interest \\ create(:interest)) do
    create(:user_interest, user: user, interest: interest).user
  end

  def with_subscription(user, announcement \\ create(:announcement)) do
    create(:subscription, user: user, announcement: announcement).user
  end

  def with_subscriber(announcement, user) do
    create(:subscription, announcement: announcement, user: user)
    |> Map.fetch!(:announcement)
  end
end
