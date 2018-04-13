defmodule Constable.Announcement do
  use Constable.Web, :model
  alias Constable.Comment
  alias Constable.User
  alias Constable.Subscription
  alias Constable.Interest
  alias Constable.AnnouncementInterest

  schema "announcements" do
    field :title
    field :body
    field :slug
    field :last_discussed_at, :utc_datetime, autogenerate: {DateTime, :utc_now, []}
    timestamps()

    belongs_to :user, User
    has_many :comments, Comment, on_delete: :delete_all
    has_many :subscriptions, Subscription, on_delete: :delete_all
    many_to_many :interests, Interest, join_through: AnnouncementInterest
    has_many :interested_users, through: [:interests, :users]
  end

  def update_changeset(announcement, params) do
    announcement
    |> cast(params, ~w(title body))
    |> validate_required([:title, :body])
    |> generate_slug()
  end

  def create_changeset(announcement, params) do
    announcement
    |> cast(params, ~w(title body user_id))
    |> validate_required([:title, :body])
    |> generate_slug()
  end

  def last_discussed_first(query \\ __MODULE__) do
    query |> order_by(desc: :last_discussed_at)
  end

  def with_announcement_list_assocs(query \\ __MODULE__) do
    from q in query, preload: [
      :user,
      interests: ^Interest.ordered_by_name,
      comments: ^newest_comments_first(),
      comments: :user
    ]
  end

  def search(query \\ __MODULE__, search_term, exclude_interests: excludes) do
    search_term = search_term |> prepare_for_tsquery

    excludes = if Enum.empty?(excludes) do
      [""]
    else
      excludes
    end

    from(a in query,
      full_join: i in assoc(a, :interests),
      group_by: a.id,
      having: fragment("NOT ARRAY_AGG(?) @> ?", i.name, ^excludes),
      order_by: a.id,
      where: fragment("to_tsvector('english', ?) || to_tsvector('english', ?) @@ plainto_tsquery('english', ?)",
        a.title,
        a.body,
        ^search_term
      )
    )
  end

  defp generate_slug(changeset) do
    case get_change(changeset, :title) do
      nil -> changeset
      title -> put_change(changeset, :slug, slugify(title))
    end
  end

  defp slugify(title) do
    Slugger.slugify_downcase(title)
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

defimpl Phoenix.Param, for: Constable.Announcement do
  def to_param(%{slug: slug, id: id}) do
    "#{id}-#{slug}"
  end
end
