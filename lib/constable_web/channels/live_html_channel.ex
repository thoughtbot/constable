defmodule ConstableWeb.LiveHtmlChannel do
  use Phoenix.Channel

  intercept ["new-comment"]

  def join(_topic, _params, socket) do
    {:ok, socket}
  end

  def handle_out("new-comment", %{comment: comment}, socket) do
    payload = %{
      announcement_id: comment.announcement_id,
      comment_html: render_comment_html(comment, socket.assigns[:current_user])
    }
    push socket, "new-comment", payload

    {:noreply, socket}
  end

  defp render_comment_html(comment, current_user) do
    Phoenix.View.render_to_string(
      ConstableWeb.AnnouncementView,
      "_comment.html",
      comment: comment,
      current_user: current_user
    )
  end
end
