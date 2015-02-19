defmodule UserChannelTest do
  use ConstableApi.TestWithEcto, async: false
  import Ecto.Query
  import ChannelTestHelper
  alias ConstableApi.Repo
  alias ConstableApi.UserChannel
  alias ConstableApi.User
  alias ConstableApi.Serializers

  test "users:current replies with the current user" do
    user = Forge.saved_user(Repo)
    Phoenix.PubSub.subscribe(ConstableApi.PubSub, self, "users:current")

    socket_with_topic("users:current")
    |> assign_current_user(user.id)
    |> handle_in_topic(UserChannel, %{})

    user = Repo.one(from u in User, where: u.id == ^user.id) |> Serializers.to_json
    assert_socket_replied_with_payload("users:current", user)
  end
end
