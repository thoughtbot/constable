defmodule Constable.User do
  use Ecto.Model

  before_insert :generate_token

  schema "users" do
    field :email
    field :token
    field :name

    timestamps
  end

  defp generate_token(changeset) do
    token = SecureRandom.urlsafe_base64(32)
    put_change changeset, :token, token
  end
end
