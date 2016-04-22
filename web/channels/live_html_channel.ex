defmodule Constable.LiveHtmlChannel do
  use Phoenix.Channel

  def join(_topic, _params, socket) do
    {:ok, socket}
  end
end
