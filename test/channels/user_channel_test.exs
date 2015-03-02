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

    authenticated_socket(user, "users:current")
    |> handle_in(UserChannel)

    user = Repo.one(from u in User, where: u.id == ^user.id) |> Serializers.to_json
    assert_socket_replied_with_payload("users:current", user)
  end
end
