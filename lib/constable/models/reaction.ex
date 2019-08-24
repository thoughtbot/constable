defmodule Constable.Reaction do
  use ConstableWeb, :model
  alias Constable.User

  schema "abstract: reaction" do
    field :emoji, :string
    belongs_to :user, User
    field :reactable_id, :integer

    timestamps()
  end

  def create_changeset(model \\ %__MODULE__{}, params) do
    model
    |> cast(params, ~w(reactable_id user_id emoji)a)
    |> validate_required([:reactable_id, :user_id, :emoji])
  end

  def build_from_changeset(reactable, changeset) do
    Ecto.build_assoc(reactable, :reactions,
      user_id: changeset.changes[:user_id],
      emoji: changeset.changes[:emoji]
    )
  end
end
