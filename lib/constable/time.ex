defmodule Constable.Time do
  def now do
    Ecto.DateTime.utc
  end

  def yesterday do
    days_ago(1)
  end

  def days_ago(count) do
    # Date.now |> Date.shift(days: -count) |> to_ecto
    GoodTimes.days_ago(count) |> to_ecto
  end

  def to_ecto(date) do
    date |> Ecto.DateTime.cast!
  end
end
