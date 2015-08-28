defmodule Constable.User do
  use Ecto.Model
  alias Constable.UserInterest
  alias Constable.Subscription

  before_insert :generate_token

  schema "users" do
    field :email
    field :token
    field :name
    field :username

    has_many :user_interests, UserInterest, on_delete: :fetch_and_delete
    has_many :subscriptions, Subscription, on_delete: :fetch_and_delete

    timestamps
  end

  defp generate_token(changeset) do
    token = SecureRandom.urlsafe_base64(32)
    put_change changeset, :token, token
  end
end
