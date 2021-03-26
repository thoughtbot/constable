defmodule Constable.Plugs.DeslugifierTest do
  use ConstableWeb.ConnCase, async: true

  alias Constable.Plugs.Deslugifier

  test "takes a slugified_key upon initialization" do
    assert Deslugifier.init(slugified_key: "id") == "id"
  end

  test "raises an error if no slugified_key is provided" do
    error_msg = "Must provide a :slugified_key to Constable.Plugs.Deslugifier"

    assert_raise RuntimeError, error_msg, fn ->
      Deslugifier.init([])
    end
  end

  test "turns an id-slugified-title into an id" do
    conn = build_conn(:get, "foo", id: "23-slugified-title")

    conn = Deslugifier.call(conn, "id")

    assert conn.params["id"] == 23
  end

  test "returns unmodified conn if key is not in params" do
    conn = build_conn(:get, "foo")

    unmodified_conn = Deslugifier.call(conn, "id")

    assert unmodified_conn == conn
  end

  test "returns unmodified conn if it fails to deslugify key" do
    conn = build_conn(:get, "foo", id: "slugified-title-no-id")

    unmodified_conn = Deslugifier.call(conn, "id")

    assert unmodified_conn == conn
  end
end
