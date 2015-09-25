defmodule Constable.UsubscribeController.Test do
  use Constable.ConnCase

  alias Constable.Repo
  alias Constable.Subscription

  setup do
    System.put_env("FRONT_END_URI", "http://localhost:8000")
    {:ok, %{}}
  end

  test "#show deletes subscription and shows a page" do
    subscription = create(:subscription)

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
