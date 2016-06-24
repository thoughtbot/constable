defmodule Constable.AnnouncementForm do
  use Ecto.Schema

  alias Constable.Announcement
  alias Constable.Services.AnnouncementCreator
  alias Constable.Services.AnnouncementInterestAssociator

  embedded_schema do
    field :title
    field :body
    field :interests
  end

  def changeset(params) do
    IO.inspect params
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
    |> Ecto.Multi.run(:after_create, fn(%{announcement: announcement}) ->
      AnnouncementCreator.after_create(announcement, interest_names)
      {:ok, nil}
    end)
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
end
