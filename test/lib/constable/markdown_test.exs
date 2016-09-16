defmodule Constable.MarkdownTest do
  use ExUnit.Case, async: true

  describe "to_html/1" do
    test "filters out JavaScript" do
      html = """
      <script>alert("Gonna steal your data!");</script>
      <a href="javascript:alert("Stolen!")>Click please!</a>
      """
      |> Constable.Markdown.to_html

      assert html == ~s[alert("Gonna steal your data!");<a>Click please!</a>]
    end
  end
end
