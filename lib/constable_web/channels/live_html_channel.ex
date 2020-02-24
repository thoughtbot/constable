defmodule ConstableWeb.LiveHtmlChannel do
  use Phoenix.Channel

  intercept ["new-comment"]

  def join(_topic, _params, socket) do
    {:ok, socket}
  end

  def handle_out("new-comment", %{comment: comment}, socket) do
    current_user = socket.assigns[:current_user]
    announcement_id = comment.announcement_id

    payload = %{
      announcement_id: announcement_id,
      comment_html: render_comment_html(comment, current_user),
      subscribed: comment.user_id == current_user.id,
      unsubscribe_button_html: render_unsubscribe_button_html(announcement_id)
    }

    push(socket, "new-comment", payload)

    {:noreply, socket}
  end

  defp render_unsubscribe_button_html(announcement_id) do
    Phoenix.View.render_to_string(
      ConstableWeb.AnnouncementView,
      "_unsubscribe_button.html",
      announcement_id: announcement_id
    )
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
