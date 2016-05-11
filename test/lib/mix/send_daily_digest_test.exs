defmodule Mix.Tasks.Constable.SendDailyDigestTest do
  use Constable.TestWithEcto, async: true
  use Bamboo.Test

  test "sends daily digest to users that want a daily digest" do
    daily_digest_user = insert(:user, daily_digest: true)
    announcement = insert(:announcement, user: daily_digest_user) |> Repo.preload(:interests)
    insert(:user, daily_digest: false)

    Mix.Tasks.Constable.SendDailyDigest.run(nil)

    assert_delivered_email Constable.Emails.daily_digest(
      [],
      [announcement],
      [daily_digest_user]
    )
  end
end
