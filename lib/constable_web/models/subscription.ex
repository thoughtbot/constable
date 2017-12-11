defmodule Constable.Subscription do
  use Constable.Web, :model
  alias Constable.Announcement
  alias Constable.User

  schema "subscriptions" do
    field :token
    belongs_to :user, User
    belongs_to :announcement, Announcement
    timestamps()
  end

  def changeset(subscription \\ %__MODULE__{}, params) do
    subscription
    |> cast(params, ~w(user_id announcement_id))
    |> generate_token
  end

  def for_announcement(announcement_id) do
    from s in __MODULE__,
      join: u in assoc(s, :user),
      where: u.active,
      where: s.announcement_id == ^announcement_id,
      preload: [:user]
  end

  defp generate_token(changeset) do
    token = SecureRandom.urlsafe_base64(32)
    put_change changeset, :token, token
  end
end
