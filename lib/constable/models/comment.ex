defmodule Constable.Comment do
  use ConstableWeb, :model
  alias Constable.Announcement
  alias Constable.User
  alias Constable.Reaction

  schema "comments" do
    field :body

    belongs_to :user, User
    belongs_to :announcement, Announcement

    has_many :reactions, {"comment_reactions", Reaction},
      foreign_key: :reactable_id,
      on_delete: :delete_all

    timestamps()
  end

  def create_changeset(model \\ %__MODULE__{}, params) do
    create_changeset(model, params, DateTime.utc_now())
  end

  def create_changeset(model, params, last_discussed_at) do
    model
    |> cast(params, ~w(announcement_id user_id body)a)
    |> validate_required(:body)
    |> set_last_discussed_at(last_discussed_at)
  end

  def update_changeset(model, params) do
    model
    |> cast(params, ~w(body)a)
    |> validate_required(:body)
  end

  defp set_last_discussed_at(changeset, last_discussed_at) do
    prepare_changes(changeset, fn changeset ->
      Announcement
      |> where(id: ^get_field(changeset, :announcement_id))
      |> changeset.repo.update_all(set: [last_discussed_at: last_discussed_at])

      changeset
    end)
  end
end
