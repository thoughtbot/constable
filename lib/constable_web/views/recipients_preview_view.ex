defmodule ConstableWeb.RecipientsPreviewView do
  use Constable.Web, :view

  def render("show.json", assigns) do
    %{ recipients_preview_html: render_recipients_preview_html(assigns) }
  end

  defp render_recipients_preview_html(assigns) do
    Phoenix.View.render_to_string(
      ConstableWeb.RecipientsPreviewView,
      "recipients_preview.html",
      assigns
    )
  end
end
