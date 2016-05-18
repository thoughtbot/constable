defmodule Constable.AnnouncementForm do
  use Ecto.Schema

  alias Constable.Announcement
  alias Constable.Services.AnnouncementInterestAssociator

  embedded_schema do
    field :title
    field :body
    field :interests
  end

  def changeset(params) do
    %__MODULE__{}
    |> Ecto.Changeset.cast(params, ~w(title body interests))
    |> Ecto.Changeset.validate_required(~w(title body interests)a)
  end

  def create(changeset, user) do
    announcement_params = announcement_params(changeset)
    |> Map.put(:user_id, user.id)
    announcement_changeset = Announcement.changeset(%Announcement{}, :create, announcement_params)
    interest_names = get_interests(changeset)

    Ecto.Multi.new
    |> Ecto.Multi.insert(:announcement, announcement_changeset)
    |> Ecto.Multi.run(:insert_interests, fn(%{announcement: announcement}) ->
      interests = AnnouncementInterestAssociator.add_interests(announcement, interest_names)
      {:ok, interests}
    end)
    |> Ecto.Multi.run(:subscribe_author, &subscribe_author/1)
    |> Ecto.Multi.run(:email_and_subscribe_users, &email_and_subscribe_users/1)
  end

  def announcement_params(changeset) do
    changeset
    |> Ecto.Changeset.apply_changes
    |> Map.take([:title, :body])
  end

  defp get_interests(changeset) do
    changeset
    |> Ecto.Changeset.apply_changes
    |> Map.get(:interests)
    |> String.split(",")
  end

  defp subscribe_author(%{announcement: announcement}) do
    author = Constable.Repo.one(assoc(announcement, :user)
    subscribe_user(author)
  end

  defp email_and_subscribe_users(%{announcement: announcement}) do
    mentioned_users = find_mentioned_users(announcement)
    interested_users = find_interested_users(announcement) -- mentioned_users
  end

  defp email_users(announcement, users) do
    users = filter_author(announcement.user_id, users)

    Emails.new_announcement(announcement, users) |> Mailer.deliver_later
    announcement
  end

  defp subscribe_user(announcement, user_id) do
    params = %{
      user_id: user_id,
      announcement_id: announcement.id
    }

    Repo.get_by(Subscription, params) || insert_subscription(params)
  end
end
