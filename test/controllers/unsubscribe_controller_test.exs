defmodule Constable.UsubscribeController.Test do
  use Constable.ConnCase, async: true

  alias Constable.Repo
  alias Constable.Subscription

  test "#show deletes subscription and shows a page" do
    subscription = insert(:subscription)

    conn = get conn(), unsubscribe_path(conn, :show, subscription.token)

    assert Repo.one(Subscription) == nil
    assert html_response(conn, 200) =~ "You've been unsubscribed"
  end

  test "#show shows the page if no subscription exists" do
    non_existent_token = "foo"

    conn = get conn(), unsubscribe_path(conn, :show, non_existent_token)

    assert html_response(conn, 200) =~ "You've been unsubscribed"
  end
end
