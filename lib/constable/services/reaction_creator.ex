defmodule Constable.Services.ReactionCreator do
  alias ConstableWeb.Api.ReactionView
  alias Constable.Reaction
  alias Constable.Repo

  def create(reactable, params) do
    changeset = Reaction.create_changeset(params)

    if changeset.valid? do
      reaction = Reaction.build_from_changeset(reactable, changeset)

      case Repo.insert(reaction) do
        {:ok, reaction} ->
          {:ok, reaction}

        {:error, changeset} ->
          {:error, changeset}
      end
    else
      {:error, changeset}
    end
  end
end
