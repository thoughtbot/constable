defmodule Constable.Subscription do
  use Ecto.Model
  alias Constable.Announcement
  alias Constable.User

  schema "subscriptions" do
    belongs_to :user, User
    belongs_to :announcement, Announcement
    timestamps
  end

  def changeset(subscription \\ %__MODULE__{}, _, params) do
    subscription
    |> cast(params, ~w(user_id announcement_id))
  end
end
