defmodule Mix.Tasks.Constable.SendDailyDigestTest do
  use Constable.TestWithEcto, async: false

  defmodule FakeDailyDigest do
    def send_email(users, time) do
      send self, {:users, users}
    end
  end

  test "calls daily digest with users that have daily digest enabled" do
    daily_digest_user = create(:user, daily_digest: true)
    create(:user, daily_digest: false)
    Pact.override self, :daily_digest, FakeDailyDigest

    Mix.Tasks.Constable.SendDailyDigest.run(nil)

    assert_receive {:users, [^daily_digest_user]}
  end
end
