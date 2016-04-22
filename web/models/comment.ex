defmodule Constable.Comment do
  use Constable.Web, :model
  alias Constable.Announcement
  alias Constable.User

  schema "comments" do
    field :body

    belongs_to :user, User
    belongs_to :announcement, Announcement
    timestamps
  end

  def changeset(model \\ %__MODULE__{}, :create, params) do
    model
    |> cast(params, ~w(announcement_id user_id body), [])
    |> set_last_discussed_at
  end

  defp set_last_discussed_at(changeset) do
    prepare_changes changeset, fn(changeset) ->
      Announcement
      |> where(id: ^get_field(changeset, :announcement_id))
      |> changeset.repo.update_all(set: [last_discussed_at: Ecto.DateTime.utc])

      changeset
    end
  end
end
