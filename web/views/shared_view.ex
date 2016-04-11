defmodule Constable.SharedView do
  def gravatar(user) do
    Exgravatar.generate(user.email, %{}, true)
  end

  def time_ago_in_words(time) do
    time
    |> Ecto.DateTime.to_erl
    |> Timex.DateTime.from_erl
    |> Timex.format!("{relative}", Timex.Format.DateTime.Formatters.Relative)
  end
end
