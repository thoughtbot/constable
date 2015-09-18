defmodule Constable.Factories do
  use ExMachina.Ecto, repo: Constable.Repo
  import Constable.FactoryHelper

  factory :email_reply_message do
    %{
      text: "My email reply",
      from_email: sequence(:email, &"test#{&1}@thoughtbot.com"),
      email: "constable-fakekey@thoughtbot.com"
    }
  end

  factory :email_reply_webhook do
    %{
      event: "inbound",
      msg: build(:email_reply_message)
    }
  end

  factory :interest do
    %Constable.Interest{
      name: sequence(:interest_name, &"interest-#{&1}")
    }
  end

  factory :user do
    %Constable.User{
      username: "myusername",
      name: "Gumbo",
      email: sequence(:email, &"test#{&1}@thoughtbot.com"),
      daily_digest: true,
      auto_subscribe: false
    }
  end

  factory :announcement do
    %Constable.Announcement{
      title: sequence(:email, &"Post Title#{&1}"),
      body: "Post Body",
      user_id: assoc(:user)
    }
  end

  factory :announcement_params do
    %{
      title: "Title",
      body: "Body",
      user_id: assoc(:user)
    }
  end

  factory :announcement_interest do
    %Constable.AnnouncementInterest{
      announcement_id: assoc(:announcement),
      interest_id: assoc(:interest)
    }
  end

  factory :comment do
    %Constable.Comment{
      body: "Post Body",
      user_id: assoc(:user),
      announcement_id: assoc(:announcement)
    }
  end

  factory :subscription do
    %Constable.Subscription{
      user_id: assoc(:user),
      announcement_id: assoc(:announcement)
    }
  end

  factory :user_interest do
    %Constable.UserInterest{
      user_id: assoc(:user),
      interest_id: assoc(:interest)
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
