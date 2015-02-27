defmodule Constable.SubscriptionChannel do
  use Constable.AuthorizedChannel
  alias Constable.Repo
  alias Constable.Subscription
  alias Constable.Serializers
  alias Constable.Queries

  def handle_in("subscriptions:index", _params, socket) do
    user_id = current_user_id(socket)
    subscriptions =
      Repo.all(Queries.Subscription.for_user(user_id))
      |> Enum.map(&preload_associations/1)
      |> Enum.map(&Serializers.to_json/1)
      |> Serializers.ids_as_keys

    reply socket, "subscriptions:index", %{subscriptions: subscriptions}
  end

  def handle_in("subscriptions:create", %{"announcement_id" => announcement_id}, socket) do
    user_id = current_user_id(socket)
    subscription = Repo.insert(%Subscription{
      user_id: user_id,
      announcement_id: announcement_id
    })

    reply socket, "subscriptions:create", Serializers.to_json(subscription)
  end

  def handle_in("subscriptions:destroy", %{"id" => id},socket) do
    Repo.get(Subscription, id)
    |> Repo.delete

    reply socket, "subscriptions:destroy", %{id: id}
  end

  defp preload_associations(subscription) do
    Repo.preload(subscription, [:announcement, :user])
  end
end
