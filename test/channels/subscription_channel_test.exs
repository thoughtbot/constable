defmodule Constable.Channels.SubscriptionChannelTest do
  use Constable.ChannelCase
  alias Constable.SubscriptionChannel
  alias Constable.Subscription

  @channel SubscriptionChannel

  test "'all' returns all subscriptions for current user" do
    user = Forge.saved_user(Repo)
    announcement = Forge.saved_announcement(Repo, user_id: user.id)
    subscription = Forge.saved_subscription(Repo,
      user_id: user.id,
      announcement_id: announcement.id
    )
    socket = join!("subscriptions", %{"token" => user.token})

    ref = push socket, "all"

    payload = payload_from_reply(ref, :ok)
    subscription = subscription |> Repo.preload([:user, :announcement])
    subscriptions = %{
      subscriptions: [subscription]
    }
    assert payload == subscriptions
  end

  test "'create' replies with the newly created subscription" do
    user = Forge.saved_user(Repo)
    announcement = Forge.saved_announcement(Repo, user_id: user.id)
    socket = join!("subscriptions", %{"token" => user.token})

    ref = push socket, "create", %{"subscription" =>
      %{"announcement_id" => announcement.id}
    }

    payload = payload_from_reply(ref, :ok)
    subscription = Repo.one(Subscription)
    assert payload == %{subscription: subscription}
  end

  test "'delete' returns the id of the deleted subscription" do
    user = Forge.saved_user(Repo)
    announcement = Forge.saved_announcement(Repo, user_id: user.id)
    subscription = Forge.saved_subscription(Repo,
      user_id: user.id,
      announcement_id: announcement.id
    )
    socket = join!("subscriptions", %{"token" => user.token})

    ref = push socket, "delete", %{"subscription" => %{
      "id" => subscription.id
    }}

    payload = payload_from_reply(ref, :ok)
    assert payload == %{subscription: %{id: subscription.id}}
  end
end
