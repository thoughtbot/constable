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
    |> cast(params, ~w(title body))
  end

  def changeset(announcement, :create, params) do
    announcement
    |> cast(params, ~w(title body user_id))
  end

  def search(query \\ __MODULE__, search_term) do
    search_term = search_term |> prepare_for_tsquery

    from(a in query,
      where: fragment("to_tsvector('english', ?) || to_tsvector('english', ?) @@ to_tsquery('english', ?)",
        a.title,
        a.body,
        ^search_term
      )
    )
  end

  defp prepare_for_tsquery(search_term) do
    search_term
    |> String.split(" ", trim: true)
    |> Enum.intersperse(" & ")
    |> Enum.join("")
  end
end
