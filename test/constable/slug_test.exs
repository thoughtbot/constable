defmodule Constable.SlugTest do
  use ExUnit.Case, async: true

  alias Constable.Slug

  describe "deslugify/1" do
    test "separates the id from the title slug" do
      title = "23-slugified-title"

      {:ok, id} = Slug.deslugify(title)

      assert id == 23
    end

    test "returns :error if no id is present" do
      title = "slugified-title"

      assert :error = Slug.deslugify(title)
    end

    test "returns :error if id is 0 (an invalid id)" do
      title = "0-slugified-title"

      assert :error = Slug.deslugify(title)
    end
  end
end
