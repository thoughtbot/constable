defmodule Constable.Services.ReactionCreator do
  alias Constable.Repo
  alias Constable.Announcement
  alias Constable.Comment
  alias Constable.AnnouncementReaction
  alias Constable.CommentReaction
  alias Constable.Reaction

  def create(reactable_params, reaction_params) do
    announcement =
      reactable_params["announcement_id"] &&
        Repo.get(Announcement, reactable_params["announcement_id"])

    comment = reactable_params["comment_id"] && Repo.get(Comment, reactable_params["comment_id"])

    reactable = announcement || comment

    if reactable do
      reaction =
        Reaction.create_changeset(reaction_params)
        |> Repo.insert!()

      changeset =
        if announcement do
          AnnouncementReaction.changeset(%{
            announcement_id: reactable.id,
            reaction_id: reaction.id
          })
        else
          CommentReaction.changeset(%{comment_id: reactable.id, reaction_id: reaction.id})
        end

      case Repo.insert(changeset) do
        {:ok, _reactable_reaction} ->
          {:ok, reaction}

        {:error, changeset} ->
          {:error, changeset}
      end
    else
      {:error,
       %Ecto.Changeset{
         errors: [invalid_reactable: {"Invalid announcement or comment id", []}],
         changes: [],
         types: []
       }}
    end
  end
end
