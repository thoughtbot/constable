defmodule Constable.V2.UsubscribeController.Test do
  use Constable.ConnCase, async: true

  alias Constable.Repo
  alias Constable.Subscription
  alias Constable.Services.SubscriptionToken

  test "#show deletes subscription and shows a page" do
    user = insert(:user)
    announcement = insert(:announcement)
    insert(:subscription, announcement: announcement, user: user)
    token = SubscriptionToken.encode(user, announcement)
    conn = build_conn()

    conn = get conn, v2_unsubscribe_path(conn, :show, token)

    assert Repo.one(Subscription) == nil
    assert redirected_to(conn) == announcement_path(conn, :show, announcement)
  end

  test "#show shows the announcement index if no subscription exists" do
    user = insert(:user)
    announcement = insert(:announcement)
    token = SubscriptionToken.encode(user, announcement)
    conn = build_conn()

    conn = get conn, v2_unsubscribe_path(conn, :show, token)

    assert redirected_to(conn) == announcement_path(conn, :index)
  end

  test "#show shows the announcement index if the token is invalid" do
    invalid_token = "foo"
    conn = build_conn()

    conn = get conn, v2_unsubscribe_path(conn, :show, invalid_token)

    assert redirected_to(conn) == announcement_path(conn, :index)
  end
end
