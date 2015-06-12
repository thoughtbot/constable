defmodule Constable.UserInterest do
  use Ecto.Model
  alias Constable.User
  alias Constable.Interest
  alias Constable.Repo

  schema "users_interests" do
    timestamps

    belongs_to :user, User
    belongs_to :interest, Interest
  end

  def changeset(user_interest \\ %__MODULE__{}, params) do
    user_interest
    |> cast(params, ~w(user_id interest_id))
    |> validate_unique(:user_id, on: Repo, scope: [:interest_id])
    |> validate_unique(:interest_id, on: Repo, scope: [:user_id])
  end
end
