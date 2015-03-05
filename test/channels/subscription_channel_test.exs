defmodule Constable.Channels.SubscriptionChannelTest do
  use Constable.TestWithEcto, async: false
  import Ecto.Query
  import ChannelTestHelper
  alias Constable.Repo
  alias Constable.SubscriptionChannel
  alias Constable.Subscription
  alias Constable.Serializers

  test "subscriptions:index returns all subscriptions for current user" do
    user = Forge.saved_user(Repo)
    announcement = Forge.saved_announcement(Repo, user_id: user.id)
    subscription = Forge.saved_subscription(Repo,
      user_id: user.id,
      announcement_id: announcement.id
    )

    authenticated_socket(user, topic: "subscriptions:index")
    |> handle_in(SubscriptionChannel)

    subscription = subscription |> Repo.preload([:user, :announcement])
    subscriptions = %{
      subscriptions: Map.put(%{}, to_string(subscription.id), subscription)
    }
    assert_socket_replied_with_payload("subscriptions:index", subscriptions)
  end

  test "subscriptions:create replies with the newly created subscription" do
    user = Forge.saved_user(Repo)
    announcement = Forge.saved_announcement(Repo, user_id: user.id)

    authenticated_socket(user, topic: "subscriptions:create")
    |> handle_in(SubscriptionChannel, %{
      "announcement_id" => announcement.id
    })

    subscription = Repo.one(Subscription)
    assert_socket_replied_with_payload("subscriptions:create", subscription)
  end

  test "subscriptions:destroy destroys a comment subscription" do
    user = Forge.saved_user(Repo)
    announcement = Forge.saved_announcement(Repo, user_id: user.id)
    subscription = Forge.saved_subscription(Repo,
      user_id: user.id,
      announcement_id: announcement.id
    )

    authenticated_socket(user, topic: "subscriptions:destroy")
    |> handle_in(SubscriptionChannel, %{
      "id" => subscription.id
    })

    assert_socket_replied_with_payload(
      "subscriptions:destroy",
      %{id: subscription.id}
    )
  end
end
