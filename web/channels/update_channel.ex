defmodule Constable.UpdateChannel do
  use Phoenix.Channel
  import Ecto.Query

  def join(_topic, _params, socket) do
    {:ok, socket}
  end
end
