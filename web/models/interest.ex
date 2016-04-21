defmodule Constable.Interest do
  use Constable.Web, :model
  alias Constable.{Announcement, AnnouncementInterest, UserInterest}

  schema "interests" do
    field :name
    field :slack_channel
    timestamps

    has_many :announcements_interests, AnnouncementInterest, on_delete: :delete_all
    has_many :announcements, through: [:announcements_interests, :announcement]
    has_many :users_interests, UserInterest, on_delete: :delete_all
    has_many :interested_users, through: [:users_interests, :user]
  end

  def changeset(interest \\ %__MODULE__{}, params) do
    interest
    |> cast(params, ~w(name), [])
    |> validate_presence(:name)
    |> update_change(:name, &String.replace(&1, "#", ""))
    |> update_change(:name, &String.downcase/1)
    |> unique_constraint(:name)
  end

  def with_announcements(query \\ __MODULE__) do
    from interest in query,
      preload: [announcements: ^Announcement.with_announcement_list_assocs]
  end

  def update_channel_changeset(interest, channel_name) do
    interest
    |> cast(%{slack_channel: channel_name}, ~w(slack_channel), [])
    |> update_change(:slack_channel, &Regex.replace(~r/^#*/, &1, "#"))
  end
end
