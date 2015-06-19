defmodule Constable.ChannelCase do
  @moduledoc """
  This module defines the test case to be used by
  channel tests.

  Such tests rely on `Phoenix.ChannelTest` and also
  imports other functionality to make it easier
  to build and query models.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with channels
      use Phoenix.ChannelTest
      use Constable.Web, :view
      # Alias the data repository and import query/model functions
      alias Constable.Repo
      import Ecto.Model
      import Ecto.Query, only: [from: 2]

      # The default endpoint for testing
      @endpoint Constable.Endpoint

      defmacro join!(topic, payload \\ Macro.escape(%{})) do
        quote do
          join!(@channel, unquote(topic), unquote(payload))
        end
      end
      def join!(channel, topic, as: user) do
        join!(channel, topic, %{"token" => user.token})
      end
      def join!(channel, topic, payload) when is_binary(topic) do
        {:ok, _, socket} = subscribe_and_join(channel, topic, payload)
        socket
      end

      def wait_for_reply(ref, status) do
        assert_reply(ref, ^status)
      end

      def payload_from_reply(ref, status) do
        assert_reply ref, status, payload
        payload
      end

      defmacro refute_broadcast(event, payload, timeout \\ 100) do
        quote do
          refute_receive %Phoenix.Socket.Broadcast{
            event: unquote(event),
            payload: unquote(payload)},
            unquote(timeout)
        end
      end
    end
  end

  setup tags do
    unless tags[:async] do
      Ecto.Adapters.SQL.restart_test_transaction(Constable.Repo, [])
    end

    :ok
  end
end
