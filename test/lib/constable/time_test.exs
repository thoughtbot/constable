defmodule Constable.TimeTest do
  use ExUnit.Case, async: true

  test "today returns todays date in Ecto.DateTime format" do
    assert Constable.Time.now == Ecto.DateTime.utc
  end

  test "today returns yesterdays date in Ecto.DateTime format" do
    yesterday = GoodTimes.a_day_ago |> Constable.Time.to_ecto
    assert Constable.Time.yesterday == yesterday
  end

  test "to_ecto turns erlang dates into ecto dates" do
    converted_time = {{2015, 10, 10}, {10, 10, 10}} |> Constable.Time.to_ecto
    assert converted_time.__struct__ == Ecto.DateTime
  end
end
