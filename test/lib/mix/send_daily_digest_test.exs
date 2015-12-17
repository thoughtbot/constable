defmodule Mix.Tasks.Constable.SendDailyDigestTest do
  use Constable.TestWithEcto, async: false

  alias Bamboo.SentEmail
  alias Bamboo.Formatter

  setup do
    Bamboo.SentEmail.reset
    :ok
  end

  test "sends daily digest to users that want a daily digest" do
    daily_digest_user = create(:user, daily_digest: true)
    create(:announcement, user: daily_digest_user)
    create(:user, daily_digest: false)

    Mix.Tasks.Constable.SendDailyDigest.run(nil)

    assert SentEmail.one.to == [Formatter.format_recipient(daily_digest_user)]
  end
end
