defmodule Constable.PubSubTest do
  use Constable.DataCase, async: true

  import Constable.Factory

  alias Constable.PubSub

  describe "broadcast_new_comment/1" do
    test "broadcasts a comment on the announcement topic" do
      announcement = insert(:announcement)
      comment = insert(:comment, announcement: announcement)
      PubSub.subscribe_to_announcement(announcement)

      :ok = PubSub.broadcast_new_comment(comment)

      assert_receive {:new_comment, ^comment}
    end
  end
end
