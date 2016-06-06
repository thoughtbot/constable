defmodule Constable.RecipientsPreviewView do
  use Constable.Web, :view

  def render("show.json", %{recipient_count: recipient_count}) do
    %{ recipients_preview_html: recipients_preview_html(recipient_count) }
  end

  defp recipients_preview_html(recipient_count) do
    Phoenix.View.render_to_string(
      Constable.RecipientsPreviewView,
      "recipients_preview.html",
      recipient_count: recipient_count
    )
  end
end
