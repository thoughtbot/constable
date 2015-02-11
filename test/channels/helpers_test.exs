defmodule ChannelHelperTest do
  use ConstableApi.TestWithEcto, async: false
  import ChannelTestHelper
  alias ConstableApi.Repo
  alias ConstableApi.Channel

  test "joins the socket when the auth token matches a user" do
    user = Forge.saved_user(Repo)
    socket = socket_with_topic

    {status, socket} = Channel.Helpers.authorize_socket(socket, user.token)

    assert status == :ok
    assert socket == socket
  end

  test "returns error when joining with an incorrect token" do
    Forge.saved_user(Repo)
    bad_token = "abc"
    socket = socket_with_topic

    {status, socket, message} = Channel.Helpers.authorize_socket(socket, bad_token)

    assert status == :error
    assert socket == socket
    assert message == :unauthorized
  end
end
