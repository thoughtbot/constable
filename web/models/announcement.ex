defmodule Constable.Announcement do
  use Ecto.Model
  alias Constable.Comment
  alias Constable.User
  alias Constable.Subscription
  alias Constable.AnnouncementInterest

  schema "announcement" do
    field :title
    field :body
    timestamps

    belongs_to :user, User
    has_many :comments, Comment, on_delete: :fetch_and_delete
    has_many :subscriptions, Subscription, on_delete: :fetch_and_delete
    has_many :announcements_interests, AnnouncementInterest, on_delete: :fetch_and_delete
    has_many :interests, through: [:announcements_interests, :interest]
    has_many :interested_users, through: [:interests, :interested_users]
  end

  def changeset(announcement, context, params \\ nil)
  def changeset(announcement, :update, params) do
    announcement
    |> cast(params, ~w(), ~w(title body))
  end

  def changeset(announcement, :create, params) do
    announcement
    |> cast(params, ~w(title body user_id))
  end
end
