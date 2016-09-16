defmodule Constable.Markdown do
  def to_html(markdown) do
    markdown
    |> Earmark.to_html
    |> HtmlSanitizeEx.basic_html
  end
end
