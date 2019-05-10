defmodule Constable.CustomScrubber do
  @moduledoc """
  This was initially copied from the MarkdownHTML Scrubber here:
  https://github.com/rrrene/html_sanitize_ex/blob/c9b05d982e988a554b56b1f9ab40df89ae14a9cf/lib/html_sanitize_ex/scrubber/markdown_html.ex
  The only change is that we add an explicit allowance for `iframe` tags at the
  very end of the definition.
  """

  require HtmlSanitizeEx.Scrubber.Meta
  alias HtmlSanitizeEx.Scrubber.Meta

  @valid_schemes ["http", "https", "mailto"]

  # Removes any CDATA tags before the traverser/scrubber runs.
  Meta.remove_cdata_sections_before_scrub()

  Meta.strip_comments()

  Meta.allow_tag_with_uri_attributes("a", ["href"], @valid_schemes)
  Meta.allow_tag_with_these_attributes("a", ["name", "title"])

  Meta.allow_tag_with_this_attribute_values("a", "target", ["_blank"])

  Meta.allow_tag_with_this_attribute_values("a", "rel", [
    "noopener",
    "noreferrer"
  ])

  Meta.allow_tag_with_these_attributes("b", [])
  Meta.allow_tag_with_these_attributes("blockquote", [])
  Meta.allow_tag_with_these_attributes("br", [])
  Meta.allow_tag_with_these_attributes("code", ["class"])
  Meta.allow_tag_with_these_attributes("del", [])
  Meta.allow_tag_with_these_attributes("em", [])
  Meta.allow_tag_with_these_attributes("h1", [])
  Meta.allow_tag_with_these_attributes("h2", [])
  Meta.allow_tag_with_these_attributes("h3", [])
  Meta.allow_tag_with_these_attributes("h4", [])
  Meta.allow_tag_with_these_attributes("h5", [])
  Meta.allow_tag_with_these_attributes("hr", [])
  Meta.allow_tag_with_these_attributes("i", [])

  Meta.allow_tag_with_uri_attributes("img", ["src"], @valid_schemes)

  Meta.allow_tag_with_these_attributes("img", [
    "width",
    "height",
    "title",
    "alt"
  ])

  Meta.allow_tag_with_these_attributes("li", [])
  Meta.allow_tag_with_these_attributes("ol", [])
  Meta.allow_tag_with_these_attributes("p", [])
  Meta.allow_tag_with_these_attributes("pre", [])
  Meta.allow_tag_with_these_attributes("span", [])
  Meta.allow_tag_with_these_attributes("strong", [])
  Meta.allow_tag_with_these_attributes("table", [])
  Meta.allow_tag_with_these_attributes("tbody", [])
  Meta.allow_tag_with_these_attributes("td", [])
  Meta.allow_tag_with_these_attributes("th", [])
  Meta.allow_tag_with_these_attributes("thead", [])
  Meta.allow_tag_with_these_attributes("tr", [])
  Meta.allow_tag_with_these_attributes("u", [])
  Meta.allow_tag_with_these_attributes("ul", [])

  # This line which allows `iframe` is the only change from the original
  # copied file referenced at the beginning of this file.
  Meta.allow_tag_with_these_attributes("iframe", [])

  Meta.strip_everything_not_covered()
end
