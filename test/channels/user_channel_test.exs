defmodule UserChannelTest do
  use Constable.ChannelCase
  alias Constable.UserChannel
  alias Constable.User

  test "users show with id 'me' replies with the current user" do
    user = Forge.saved_user(Repo)
    socket = join!(UserChannel, "users", %{"token" => user.token})

    ref = push socket, "show", %{"id" => "me"}

    payload = payload_from_reply(ref, :ok)
    user = Repo.get(User, user.id) |> preload_associations
    assert payload == %{user: user}
  end

  test "users show with id replies with the user with that id" do
    user = Forge.saved_user(Repo)
    another_user = Forge.saved_user(Repo)
    socket = join!(UserChannel, "users", %{"token" => user.token})

    ref = push socket, "show", %{"id" => another_user.id}

    payload = payload_from_reply(ref, :ok)
    user = Repo.get(User, another_user.id) |> preload_associations
    assert payload == %{user: user}
  end

  def preload_associations(user) do
    Repo.preload(user, [:subscriptions, :user_interests])
  end
end
