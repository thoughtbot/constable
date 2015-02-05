defmodule ConstableApi.User do
  use Ecto.Model

  before_insert :generate_token

  schema "users" do
    field :email
    field :token

    timestamps
  end

  defp generate_token(changeset) do
    token = SecureRandom.urlsafe_base64(32)
    put_change changeset, :token, token
  end
end
