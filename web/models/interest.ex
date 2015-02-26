defmodule Constable.Interest do
  use Ecto.Model

  schema "interests" do
    field :name
    timestamps

    has_many :announcements_interests, AnnouncementInterest
    has_many :announcements, through: [:announcements_interests, :announcement]
  end

  def changeset(interest, params) do
    params
    |> cast(interest, ~w(name))
    |> update_change(:name, &String.downcase/1)
  end
end
