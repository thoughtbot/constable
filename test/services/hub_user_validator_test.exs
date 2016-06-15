defmodule Constable.HubValidatorTest do
  use Constable.TestWithEcto

  alias Constable.{HubUserValidator, User}

  test "disable_invalid_users deactivates all users who don't match active people" do
    insert(:user, email: "joe@dirt.com")
    insert(:user, email: "invalid@dirt.com")
    valid_emails = ["joe@dirt.com", "foo@bar.net"]

    HubUserValidator.disable_users_not_in(valid_emails)

    active_user = Repo.get_by(User, email: "joe@dirt.com")
    inactive_user = Repo.get_by(User, email: "invalid@dirt.com")

    assert active_user.active
    refute inactive_user.active
  end

  test "does not deactivate users in @ignored_users" do
    insert(:user, email: "ralph@thoughtbot.com")
    valid_emails = ["joe@dirt.com", "foo@bar.net"]

    HubUserValidator.disable_users_not_in(valid_emails)

    ralph = Repo.get_by(User, email: "ralph@thoughtbot.com")

    assert ralph.active
  end
end
