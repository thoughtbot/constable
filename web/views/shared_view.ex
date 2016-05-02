defmodule Constable.SharedView do
  require Ecto.Query

  alias Constable.Services.MentionFinder

  def gravatar(user) do
    Exgravatar.generate(user.email, %{}, true)
  end

  def time_ago_in_words(time) do
    time
    |> Ecto.DateTime.to_erl
    |> Timex.DateTime.from_erl
    |> Timex.format!("{relative}", Timex.Format.DateTime.Formatters.Relative)
  end

  def markdown_with_users(markdown) do
    markdown
    |> MentionFinder.find_users
    |> bold_usernames(markdown)
    |> Earmark.to_html
  end

  defp bold_usernames(users, text) do
    Enum.reduce(users, text, fn(user, text) ->
      String.replace(text, "@#{user.username}", "**@#{user.username}**")
    end)
  end
end
