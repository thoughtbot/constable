defmodule Constable.Announcement do
  use Constable.Web, :model
  alias Constable.Comment
  alias Constable.User
  alias Constable.Subscription
  alias Constable.AnnouncementInterest

  schema "announcements" do
    field :title
    field :body
    field :last_discussed_at, Ecto.DateTime
    @ecto_autogenerate_insert {:last_discussed_at, Ecto.DateTime, [:sec]}
    timestamps

    belongs_to :user, User
    has_many :comments, Comment, on_delete: :delete_all
    has_many :subscriptions, Subscription, on_delete: :delete_all
    has_many :announcements_interests, AnnouncementInterest, on_delete: :delete_all
    has_many :interests, through: [:announcements_interests, :interest]
    has_many :interested_users, through: [:interests, :interested_users]
  end

  def changeset(announcement, context, params \\ %{})
  def changeset(announcement, :update, params) do
    announcement
    |> cast(params, ~w(title body), [])
  end

  def changeset(announcement, :create, params) do
    announcement
    |> cast(params, ~w(title body user_id), [])
  end

  def last_discussed_first(query \\ __MODULE__) do
    query |> order_by(desc: :last_discussed_at)
  end

  def with_announcement_list_assocs(query \\ __MODULE__) do
    from q in query, preload: [
      :interests,
      :user,
      comments: ^newest_comments_first,
      comments: :user
    ]
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

  defp newest_comments_first do
    from(c in Comment, order_by: [asc: c.inserted_at])
  end
end
