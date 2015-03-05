defmodule UserChannelTest do
  use Constable.TestWithEcto, async: false
  import Ecto.Query
  import ChannelTestHelper
  alias Constable.Repo
  alias Constable.UserChannel
  alias Constable.User
  alias Constable.Serializers
  alias Constable.Router

  test "users:current replies with the current user" do
    user = Forge.saved_user(Repo)

    authenticated_socket(user, "users:current")
    |> handle_in(UserChannel)

    user = Repo.get(User, user.id)
    assert_socket_replied_with_payload("users:current", user)
  end
end
