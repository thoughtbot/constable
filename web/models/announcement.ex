defmodule Constable.Announcement do
  use Ecto.Model
  alias Constable.Comment
  alias Constable.User
  alias Constable.AnnouncementInterest

  schema "announcement" do
    field :title
    field :body
    timestamps

    belongs_to :user, User
    has_many :comments, Comment
    has_many :announcements_interests, AnnouncementInterest
    has_many :interests, through: [:announcements_interests, :interest]
    has_many :interested_users, through: [:interests, :interested_users]
  end

  def changeset(announcement, :create, params) do
    announcement
    |> cast(params, ~w(title body user_id))
  end

  def changeset(announcement, :update, params \\ nil) do
    announcement
    |> cast(params, ~w(), ~w(title body))
  end
end
