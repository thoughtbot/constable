defmodule ConstableWeb.Api.SubscriptionControllerTest do
  import Ecto.Query
  use ConstableWeb.ConnCase, async: true

  alias Constable.Subscription

  setup do
    {:ok, api_authenticate()}
  end

  test "#index shows all current users subscriptions", %{conn: conn, user: user} do
    other_user = insert(:user)
    subscription_1 = insert(:subscription, user: user)
    subscription_2 = insert(:subscription, user: user)
    insert(:subscription, user: other_user)

    conn = get conn, api_subscription_path(conn, :index)

    ids = fetch_json_ids("subscriptions", conn)
    assert ids == [subscription_1.id, subscription_2.id]
  end

  test "#create subscribes the current user to an announcement", %{conn: conn, user: user} do
    announcement = insert(:announcement)
    post conn, api_subscription_path(conn, :create), subscription: %{
      announcement_id: announcement.id
    }

    subscription = Repo.one!(Subscription)
    assert subscription.user_id == user.id
    assert subscription.announcement_id == announcement.id
  end

  test "#delete destroys subscription", %{conn: conn, user: user} do
    subscription = insert(:subscription, user: user)

    conn = delete conn, api_subscription_path(conn, :delete, subscription.id)

    assert response(conn, 204)
  end

  test "#delete can only destroys current users subscriptions", %{conn: conn} do
    other_user = insert(:user)
    subscription = insert(:subscription, user: other_user)

    conn = delete conn, api_subscription_path(conn, :delete, subscription.id)

    assert response(conn, 401)
  end
end
