defmodule Constable.AnnouncementReaction do
  use ConstableWeb, :model
  alias Constable.Announcement
  alias Constable.Reaction

  schema "announcement_reactions" do
    belongs_to :announcement, Announcement
    belongs_to :reaction, Reaction
  end

  def changeset(model \\ %__MODULE__{}, params) do
    model
    |> cast(params, ~w(announcement_id reaction_id)a)
    |> unique_constraint(:announcement_id, name: :announcement_reaction_announcement_id_index)
    |> unique_constraint(:reaction_id, name: :announcement_reaction_reaction_id_index)
  end
end
