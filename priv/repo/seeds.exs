# Run with mix run priv/repo/seeds.exs

alias Constable.Repo
import Constable.Factory

Repo.get_by(Constable.Interest, name: "everyone") || insert(:interest, name: "everyone")
