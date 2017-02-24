defmodule Constable.UserInterest do
  use Constable.Web, :model
  alias Constable.User
  alias Constable.Interest

  schema "users_interests" do
    timestamps()

    belongs_to :user, User
    belongs_to :interest, Interest
  end

  def changeset(user_interest \\ %__MODULE__{}, params) do
    user_interest
    |> cast(params, ~w(user_id interest_id))
    |> unique_constraint(:user_id, name: :users_interests_interest_id_user_id_index)
    |> unique_constraint(:interest_id, name: :users_interests_interest_id_user_id_index)
  end
end
