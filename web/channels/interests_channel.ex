defmodule Constable.InterestChannel do
  use Constable.AuthorizedChannel
  alias Constable.Interest
  alias Constable.Repo
  alias Constable.Serializers

  def handle_in("all", _, socket) do
    interests = Repo.all(Interest)

    {:reply, {:ok, %{interests: interests}}, socket}
  end
end
