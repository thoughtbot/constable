defmodule Constable.Markdown do
  alias Earmark.Options

  def to_html(markdown) do
    markdown
    |> Earmark.as_html!(%Options{smartypants: false})
    |> HtmlSanitizeEx.html5()
  end
end
