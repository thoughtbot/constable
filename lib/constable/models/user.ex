defmodule Constable.User do
  use ConstableWeb, :model
  alias Constable.Repo
  alias Constable.UserInterest
  alias Constable.Subscription

  @permitted_email_domain Application.fetch_env!(:constable, :permitted_email_domain)

  defimpl Bamboo.Formatter do
    def format_email_address(user, _opts) do
      {user.name, user.email}
    end
  end

  schema "users" do
    field :email
    field :token
    field :name
    field :username
    field :auto_subscribe, :boolean, default: true
    field :daily_digest, :boolean, default: true
    field :active, :boolean, default: true

    has_many :comments, Constable.Comment
    has_many :user_interests, UserInterest, on_delete: :delete_all
    has_many :interests, through: [:user_interests, :interest]
    has_many :interesting_announcements, through: [:interests, :announcements]
    has_many :subscriptions, Subscription, on_delete: :delete_all

    timestamps()
  end

  def reactivate(email) when is_binary(email) do
    Repo.get_by!(__MODULE__, email: email)
    |> Ecto.Changeset.change(%{active: true})
    |> Repo.update!()
  end

  def settings_changeset(user, params \\ %{}) do
    user
    |> cast(params, ~w(auto_subscribe daily_digest name)a)
    |> validate_length(:name, min: 3)
  end

  def create_changeset(user \\ %__MODULE__{}, params) do
    user
    |> cast(params, ~w(email name)a)
    |> validate_required(:email)
    |> require_permitted_email_domain
    |> generate_token
    |> generate_username
    |> ensure_name_is_set
  end

  def interested_in?(user, interest) do
    interest.id in Enum.map(user.interests, & &1.id)
  end

  def ordered_by_name(query \\ __MODULE__) do
    query |> order_by(asc: :name)
  end

  def active(query \\ __MODULE__) do
    query |> where(active: true)
  end

  def with_email(email) do
    from u in __MODULE__, where: u.email == ^email
  end

  defp require_permitted_email_domain(changeset) do
    changeset
    |> validate_change(:email, fn :email, value ->
      case String.split(value, "@") do
        [_, @permitted_email_domain] -> []
        _ -> [email: "must be a member of #{@permitted_email_domain}"]
      end
    end)
  end

  defp generate_token(changeset) do
    token = SecureRandom.urlsafe_base64(32)
    put_change(changeset, :token, token)
  end

  defp generate_username(changeset) do
    if changeset.valid? do
      email = get_change(changeset, :email)
      [username, _] = String.split(email, "@")
      put_change(changeset, :username, username)
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
    case String.trim(string) do
      "" -> true
      _ -> false
    end
  end
end
