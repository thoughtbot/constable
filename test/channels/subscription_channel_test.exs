defmodule ConstableApi.Channels.SubscriptionChannelTest do
  use ConstableApi.TestWithEcto, async: false
  import Ecto.Query
  import ChannelTestHelper
  alias ConstableApi.Repo
  alias ConstableApi.SubscriptionChannel
  alias ConstableApi.Subscription
  alias ConstableApi.Serializers

  test "subscriptions:index returns all subscriptions for current user" do
    user = Forge.saved_user(Repo)
    announcement = Forge.saved_announcement(Repo, user_id: user.id)
    subscription = Forge.saved_subscription(Repo,
      user_id: user.id,
      announcement_id: announcement.id
    )

    socket_with_topic("subscriptions:index")
    |> assign_current_user(user.id)
    |> handle_in_topic(SubscriptionChannel)

    assert_socket_replied_with_payload("subscriptions:index", %{
      subscriptions: [Serializers.to_json(subscription)]
    })
  end

  test "subscriptions:create replies with the newly created subscription" do
    user = Forge.saved_user(Repo)
    announcement = Forge.saved_announcement(Repo, user_id: user.id)
    Phoenix.PubSub.subscribe(ConstableApi.PubSub, self, "subscriptions:create")

    socket_with_topic("subscriptions:create")
    |> assign_current_user(user.id)
    |> handle_in_topic(SubscriptionChannel, %{
      "announcement_id" => announcement.id
    })

    subscription =
      Repo.one(from s in Subscription) |>
      Repo.preload([:announcement, :user])

    assert_socket_replied_with_payload(
      "subscriptions:create",
      Serializers.to_json(subscription)
    )
  end

  test "subscriptions:destroy destroys a comment subscription" do
    user = Forge.saved_user(Repo)
    announcement = Forge.saved_announcement(Repo, user_id: user.id)
    subscription = Forge.saved_subscription(Repo,
      user_id: user.id,
      announcement_id: announcement.id
    )

    Phoenix.PubSub.subscribe(ConstableApi.PubSub, self, "subscriptions:destroy")
    socket_with_topic("subscriptions:destroy")
    |> assign_current_user(user.id)
    |> handle_in_topic(SubscriptionChannel, %{
      "id" => subscription.id
    })

    assert_socket_replied_with_payload(
      "subscriptions:destroy",
      %{deleted: true}
    )
  end
end
