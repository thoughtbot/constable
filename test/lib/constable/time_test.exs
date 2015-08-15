defmodule Constable.TimeTest do
  use ExUnit.Case, async: true

  test "today returns todays date in Ecto.DateTime format" do
    assert Constable.Time.now == Constable.Time.to_ecto(Timex.Date.now)
  end

  test "today returns yesterdays date in Ecto.DateTime format" do
    yesterday = Timex.Date.now |> Timex.Date.shift(days: -1) |> Constable.Time.to_ecto
    assert Constable.Time.yesterday == yesterday
  end

  test "to_ecto turns Timex dates into ecto dates" do
    converted_time = Timex.Date.now |> Constable.Time.to_ecto
    assert converted_time.__struct__ == Ecto.DateTime
  end
end
