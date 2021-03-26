defmodule Constable.PubSub do
  def subscribe_to_announcement(announcement) do
    Phoenix.PubSub.subscribe(__MODULE__, announcement_topic(announcement.id))
  end

  def broadcast_new_comment(comment) do
    Phoenix.PubSub.broadcast(
      __MODULE__,
      announcement_topic(comment.announcement_id),
      {:new_comment, comment}
    )
  end

  defp announcement_topic(announcement_id) do
    "announcement:#{announcement_id}"
  end
end
