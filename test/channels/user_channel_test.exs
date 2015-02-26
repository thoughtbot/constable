defmodule UserChannelTest do
  use Constable.TestWithEcto, async: false
  import Ecto.Query
  import ChannelTestHelper
  alias Constable.Repo
  alias Constable.UserChannel
  alias Constable.User
  alias Constable.Serializers

  test "users:current replies with the current user" do
    user = Forge.saved_user(Repo)
    Phoenix.PubSub.subscribe(Constable.PubSub, self, "users:current")

    socket_with_topic("users:current")
    |> assign_current_user(user.id)
    |> handle_in_topic(UserChannel, %{})

    user = Repo.one(from u in User, where: u.id == ^user.id) |> Serializers.to_json
    assert_socket_replied_with_payload("users:current", user)
  end
end
