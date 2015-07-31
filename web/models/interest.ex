defmodule Constable.Interest do
  use Constable.Web, :model
  alias Constable.Repo
  alias Constable.UserInterest
  alias Constable.AnnouncementInterest

  schema "interests" do
    field :name
    timestamps

    has_many :announcements_interests, AnnouncementInterest
    has_many :announcements, through: [:announcements_interests, :announcement]
    has_many :users_interests, UserInterest
    has_many :interested_users, through: [:users_interests, :user]
  end

  def changeset(interest \\ %__MODULE__{}, params) do
    interest
    |> cast(params, ~w(name))
    |> validate_presence(:name)
    |> update_change(:name, &String.replace(&1, "#", ""))
    |> update_change(:name, &String.downcase/1)
    |> validate_unique(:name, on: Repo)
  end
end
