defmodule ConstableWeb.Api.ReactionView do
  use ConstableWeb, :view

  def render("index.json", %{reactions: reactions}) do
    %{reactions: render_many(reactions, __MODULE__, "reaction.json")}
  end

  def render("show.json", %{reaction: reaction}) do
    %{reaction: render_one(reaction, __MODULE__, "reaction.json")}
  end

  def render("reaction.json", %{reaction: reaction}) do
    reaction = reaction |> Repo.preload(:user)

    %{
      id: reaction.id,
      emoji: reaction.emoji,
      user_name: reaction.user.name
    }
  end
end
