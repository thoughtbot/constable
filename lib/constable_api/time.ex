defmodule Constable.Time do
  alias Timex.Date

  def now do
    Date.now |> to_ecto
  end

  def yesterday do
    days_ago(1)
  end

  def days_ago(count) do
    Date.now |> Date.shift(days: -count) |> to_ecto
  end

  def to_ecto(date) do
    date |> Timex.Date.Convert.to_erlang_datetime |> Ecto.DateTime.from_erl
  end
end
