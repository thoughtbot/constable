defmodule Blacksmith.Config do
  def save(repo, map) do
    repo.insert!(map)
  end

  def save_all(repo, list) do
    Enum.map(list, &repo.insert!/1)
  end
end
