defmodule Constable.Subscription do
  use Ecto.Model
  alias Constable.Announcement
  alias Constable.User

  before_insert :generate_token

  schema "subscriptions" do
    field :token
    belongs_to :user, User
    belongs_to :announcement, Announcement
    timestamps
  end

  def changeset(subscription \\ %__MODULE__{}, _, params) do
    subscription
    |> cast(params, ~w(user_id announcement_id), [])
  end

  defp generate_token(changeset) do
    token = SecureRandom.urlsafe_base64(32)
    put_change changeset, :token, token
  end
end
