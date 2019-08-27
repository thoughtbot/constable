defmodule Constable.Reaction do
  use ConstableWeb, :model
  alias Constable.User

  schema "reactions" do
    field :emoji, :string
    belongs_to :user, User

    timestamps()
  end

  def create_changeset(model \\ %__MODULE__{}, params) do
    model
    |> cast(params, ~w(user_id emoji)a)
    |> validate_required([:emoji])
  end
end
