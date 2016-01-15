defmodule Constable.User do
  use Ecto.Model
  alias Constable.UserInterest
  alias Constable.Subscription

  defimpl Bamboo.Formatter, for: __MODULE__ do
    def format_recipient(user) do
      %{name: user.name, address: user.email}
    end
  end

  before_insert :generate_token

  schema "users" do
    field :email
    field :token
    field :name
    field :username
    field :auto_subscribe, :boolean, default: true
    field :daily_digest, :boolean, default: true

    has_many :user_interests, UserInterest, on_delete: :delete_all
    has_many :subscriptions, Subscription, on_delete: :delete_all

    timestamps
  end

  def changeset(user, params) do
    user |> cast(params, ~w(), ~w(auto_subscribe daily_digest name))
  end

  def create_changeset(user \\ %__MODULE__{}, params) do
    user
    |> cast(params, ~w(email), ~w(name))
    |> require_thoughtbot_email
    |> generate_token
    |> generate_username
    |> ensure_name_is_set
  end

  defp require_thoughtbot_email(changeset) do
    changeset
    |> validate_change(:email, fn(:email, value) ->
      case String.split(value, "@") do
        [_, "thoughtbot.com"] -> []
        _ -> [email: "must be a member of thoughtbot"]
      end
    end)
  end

  defp generate_token(changeset) do
    token = SecureRandom.urlsafe_base64(32)
    put_change changeset, :token, token
  end

  defp generate_username(changeset) do
    email = get_change(changeset, :email)
    if email do
      [username, _] = String.split(email, "@")
      put_change changeset, :username, username
    else
      changeset
    end
  end

  defp ensure_name_is_set(changeset) do
    username = changeset |> get_change(:username)
    if get_change(changeset, :name) |> is_blank? do
      changeset |> put_change(:name, username)
    else
      changeset
    end
  end

  defp is_blank?(nil), do: true
  defp is_blank?(string) when is_binary(string) do
    case String.strip(string) do
      "" -> true
      _ -> false
    end
  end
end
