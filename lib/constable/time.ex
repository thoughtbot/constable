defmodule Constable.Time do
  def now do
    DateTime.utc_now()
  end

  def yesterday do
    days_ago(1)
  end

  def days_ago(count) do
    GoodTimes.days_ago(count) |> cast!
  end

  def cast!(time) do
    time |> NaiveDateTime.from_erl!() |> DateTime.from_naive!("Etc/UTC")
  end
end
