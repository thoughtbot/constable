defmodule ConstableWeb.UsubscribeControllerTest do
  use ConstableWeb.ConnCase, async: true

  alias Constable.Repo
  alias Constable.Subscription

  test "#show deletes subscription and shows a page" do
    announcement = insert(:announcement)
    subscription = insert(:subscription, announcement: announcement)
    conn = build_conn()

    conn = get conn, unsubscribe_path(conn, :show, subscription.token)

    assert Repo.one(Subscription) == nil
    assert redirected_to(conn) == announcement_path(conn, :show, announcement)
  end

  test "#show shows the page if no subscription exists" do
    non_existent_token = "foo"
    conn = build_conn()

    conn = get conn, unsubscribe_path(conn, :show, non_existent_token)

    assert redirected_to(conn) == announcement_path(conn, :index)
  end
end
