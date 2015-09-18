defmodule Constable.Factories do
  use ExMachina.Ecto, repo: Constable.Repo

  def factory(:email_reply_message) do
    %{
      text: "My email reply",
      from_email: sequence(:email, &"test#{&1}@thoughtbot.com"),
      email: "constable-fakekey@thoughtbot.com"
    }
  end

  def factory(:email_reply_webhook) do
    %{
      event: "inbound",
      msg: build(:email_reply_message)
    }
  end

  def factory(:interest) do
    %Constable.Interest{
      name: sequence(:interest_name, &"interest-#{&1}")
    }
  end

  def factory(:user) do
    %Constable.User{
      username: "myusername",
      name: "Gumbo",
      email: sequence(:email, &"test#{&1}@thoughtbot.com"),
      daily_digest: true,
      auto_subscribe: false
    }
  end

  def factory(:announcement, attrs) do
    %Constable.Announcement{
      title: sequence(:email, &"Post Title#{&1}"),
      body: "Post Body",
      user_id: assoc(attrs, :user).id
    }
  end

  def factory(:announcement_params, attrs) do
    %{
      title: "Title",
      body: "Body",
      user_id: assoc(attrs, :user).id
    }
  end

  def factory(:announcement_interest, attrs) do
    %Constable.AnnouncementInterest{
      announcement_id: assoc(attrs, :announcement).id,
      interest_id: assoc(attrs, :interest).id
    }
  end

  def factory(:comment, attrs) do
    %Constable.Comment{
      body: "Post Body",
      user_id: assoc(attrs, :user).id,
      announcement_id: assoc(attrs, :announcement).id
    }
  end

  def factory(:subscription, attrs) do
    %Constable.Subscription{
      user_id: assoc(attrs, :user).id,
      announcement_id: assoc(attrs, :announcement).id
    }
  end

  def factory(:user_interest, attrs) do
    %Constable.UserInterest{
      user_id: assoc(attrs, :user).id,
      interest_id: assoc(attrs, :interest).id
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

  def with_subscription(user) do
    create(:subscription, user: user).user
  end

  def with_subscriber(announcement, user) do
    create(:subscription, announcement: announcement, user: user)
    |> Map.fetch!(:announcement)
  end
end
