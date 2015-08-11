defmodule Constable.UserSocket do
  use Phoenix.Socket

  channel "announcements*", Constable.AnnouncementChannel
  channel "comments*", Constable.CommentChannel
  channel "interests*", Constable.InterestChannel
  channel "subscriptions*", Constable.SubscriptionChannel
  channel "users*", Constable.UserChannel
  channel "user_interests*", Constable.UserInterestChannel

  transport :websocket, Phoenix.Transports.WebSocket
  transport :longpoll, Phoenix.Transports.LongPoll

  def connect(_params, socket) do
    {:ok, socket}
  end

  # Socket id's are topics that allow you to identify all sockets for a given user:
  #
  #     def id(socket), do: "users_socket:#{socket.assigns.user_id}"
  #
  # Would allow you to broadcast a "disconnect" event and terminate
  # all active sockets and channels for a given user:
  #
  #     MyApp.Endpoint.broadcast("users_socket:" <> user.id, "disconnect", %{})
  #
  # Returning `nil` makes this socket anonymous.
  def id(_socket), do: nil
end
