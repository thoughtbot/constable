defmodule Constable.Interest do
  defimpl Phoenix.Param do
    def to_param(%{name: name}) do
      "#{name}"
    end
  end

  use Constable.Web, :model
  alias Constable.{Announcement, User}
  alias Constable.{AnnouncementInterest, UserInterest}

  schema "interests" do
    field :name
    field :slack_channel
    timestamps()

    many_to_many :announcements, Announcement, join_through: AnnouncementInterest
    many_to_many :users, User, join_through: UserInterest
  end

  def changeset(interest \\ %__MODULE__{}, params) do
    interest
    |> cast(params, ~w(name slack_channel))
    |> validate_required(:name)
    |> update_change(:name, &String.strip(&1))
    |> update_change(:name, &String.replace(&1, "#", ""))
    |> update_change(:name, &String.replace(&1, " ", "-"))
    |> update_change(:name, &String.downcase/1)
    |> unique_constraint(:name)
  end

  def update_channel_changeset(interest, channel_name) do
    interest
    |> cast(%{slack_channel: channel_name}, ~w(slack_channel))
    |> update_change(:slack_channel, &Regex.replace(~r/^#*/, &1, "#"))
  end

  def ordered_by_name(query \\ __MODULE__) do
    from i in query, order_by: [asc: i.name]
  end
end
