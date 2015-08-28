defmodule Constable.Api.SubscriptionControllerTest do
  import Ecto.Query
  use Constable.ConnCase

  alias Constable.Subscription

  setup do
    {:ok, authenticate}
  end

  test "#index shows all current users subscriptions", %{conn: conn, user: user} do
    other_user = Forge.saved_user(Repo)
    announcement = Forge.saved_announcement(Repo, user_id: user.id)
    other_announcement = Forge.saved_announcement(Repo, user_id: user.id)

    subscription_1 = Forge.saved_subscription(Repo, user_id: user.id, announcement_id: announcement.id)
    subscription_2= Forge.saved_subscription(Repo, user_id: user.id, announcement_id: other_announcement.id)
    Forge.saved_subscription(Repo, user_id: other_user.id, announcement_id: announcement.id)

    conn = get conn, subscription_path(conn, :index)

    json_response(conn, 200)["subscriptions"]
    ids = fetch_json_ids("subscriptions", conn)

    assert ids == [subscription_1.id, subscription_2.id]
  end

  test "#create subscribes the current user to an announcement", %{conn: conn, user: user} do
    announcement = Forge.saved_announcement(Repo, user_id: user.id)
    conn = post conn, subscription_path(conn, :create), subscription: %{
      announcement_id: announcement.id
    }

    json_response(conn, 201)

    subscription = Repo.one!(Subscription)

    assert subscription.user_id == user.id
    assert subscription.announcement_id == announcement.id
  end

  test "#delete destroys subscription", %{conn: conn, user: user} do
    announcement = Forge.saved_announcement(Repo, user_id: user.id)
    subscription = Forge.saved_subscription(Repo, user_id: user.id, announcement_id: announcement.id)

    conn = delete conn, subscription_path(conn, :delete, subscription.id)

    assert response(conn, 204)
  end

  test "#delete can only destroys current users subscriptions", %{conn: conn} do
    user = Forge.saved_user(Repo)
    announcement = Forge.saved_announcement(Repo, user_id: user.id)
    subscription = Forge.saved_subscription(Repo, user_id: user.id, announcement_id: announcement.id)

    conn = delete conn, subscription_path(conn, :delete, subscription.id)

    assert response(conn, 401)
  end
end
