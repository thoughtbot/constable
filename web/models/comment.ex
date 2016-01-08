defmodule Constable.Comment do
  use Ecto.Model
  alias Constable.Announcement
  alias Constable.User

  schema "comments" do
    field :body

    belongs_to :user, User
    belongs_to :announcement, Announcement
    timestamps
  end

  def changeset(model_or_changeset \\ %__MODULE__{}, :create, params) do
    model_or_changeset
    |> cast(params, ~w(announcement_id user_id body), [])
  end
end
