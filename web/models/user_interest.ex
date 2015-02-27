defmodule Constable.UserInterest do
  use Ecto.Model
  alias Constable.User
  alias Constable.Interest

  schema "users_interests" do
    timestamps

    belongs_to :user, User
    belongs_to :interest, Interest
  end

  def changeset(user_interest, params) do
    params
    |> cast(user_interest, ~w(user_id interest_id))
  end
end
