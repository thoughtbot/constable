defmodule Constable.UserSocket do
  use Phoenix.Socket

  channel "announcements*", Constable.AnnouncementChannel
  channel "comments*", Constable.CommentChannel
  channel "interests*", Constable.InterestChannel
  channel "subscriptions*", Constable.SubscriptionChannel
  channel "users*", Constable.UserChannel
  channel "user_interests*", Constable.UserInterestChannel

  transport :websocket, Phoenix.Transports.WebSocket, check_origin: false
  transport :longpoll, Phoenix.Transports.LongPoll

  def connect(_params, socket) do
    {:ok, socket}
  end

  def id(_socket), do: nil
end
