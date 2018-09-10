defmodule Constable.Services.MentionFinder do
  @mention_regex ~r/@(\w+)/

  alias Constable.Repo
  alias Constable.User

  def find_users(text) do
    Regex.scan(@mention_regex, text)
    |> Enum.map(fn ([_, username]) -> username end)
    |> Enum.map(&(Repo.get_by(User.active, username: &1)))
    |> Enum.reject(&is_nil/1)
  end
end
