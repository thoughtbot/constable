defmodule Constable.CommentReaction do
  use ConstableWeb, :model
  alias Constable.Comment
  alias Constable.Reaction

  schema "comment_reactions" do
    belongs_to :comment, Comment
    belongs_to :reaction, Reaction
  end

  def changeset(model \\ %__MODULE__{}, params) do
    model
    |> cast(params, ~w(comment_id reaction_id)a)
    |> unique_constraint(:comment_id, name: :comment_reaction_comment_id_index)
    |> unique_constraint(:reaction_id, name: :comment_reaction_reaction_id_index)
  end
end
