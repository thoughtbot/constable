defmodule Constable.UsubscribeController.Test do
  use Constable.ConnCase

  alias Constable.Repo
  alias Constable.Subscription

  setup do
    System.put_env("FRONT_END_URI", "http://localhost:8000")
    {:ok, %{}}
  end

  test "#show deletes subscription" do
    subscription = create(:subscription)

    get conn, unsubscribe_path(conn, :show, subscription.token)

    assert Repo.one(Subscription) == nil
  end
end
