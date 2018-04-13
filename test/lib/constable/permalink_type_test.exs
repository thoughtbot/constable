defmodule Constable.PermalinkTypeTest do
  use ExUnit.Case, async: true

  alias Constable.PermalinkType

  test "type/0 is :id" do
    assert :id == PermalinkType.type()
  end

  describe ".cast/1" do
    test "casts integers" do
      value = 1

      cast_value = PermalinkType.cast(value)

      assert cast_value == {:ok, value}
    end

    test "casts slugs" do
      value = "1-some-title"

      cast_value = PermalinkType.cast(value)

      assert cast_value == {:ok, 1}
    end

    test "returns error if cannot cast slug" do
      value = "some-title"

      cast_value = PermalinkType.cast(value)

      assert cast_value == :error
    end

    test "returns error for all other cases" do
      value = %{}

      cast_value = PermalinkType.cast(value)

      assert cast_value == :error
    end
  end

  describe ".dump/1" do
    test "dumps integers" do
      assert {:ok, 11} == PermalinkType.dump(11)
    end
  end

  describe ".load/1" do
    test "loads integers" do
      assert {:ok, 12} == PermalinkType.load(12)
    end
  end
end
