defmodule Mix.Tasks.Constable.SendDailyDigestTest do
  use Constable.TestWithEcto, async: false

  alias Constable.Repo

  defmodule FakeDailyDigest do
    def send_email(users) do
      send self, {:users, users}
    end
  end

  test "calls daily digest with users that have daily digest enabled" do
    daily_digest_user = Forge.saved_user(Repo, daily_digest: true)
    user = Forge.saved_user(Repo, daily_digest: false)

    Pact.override self, :daily_digest, FakeDailyDigest
    Mix.Tasks.Constable.SendDailyDigest.run(nil)

    assert_receive {:users, [^daily_digest_user]}
  end
end
