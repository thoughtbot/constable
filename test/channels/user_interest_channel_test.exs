defmodule UserInterestChannelTest do
  use Constable.TestWithEcto, async: false
  import ChannelTestHelper
  require Forge
  alias Constable.Repo
  alias Constable.UserInterestChannel
  alias Constable.UserInterest

  test "users_interests:index replies with user's interests" do
    user = Forge.saved_user(Repo)
    Forge.having user_id: user.id do
      users_interests = [
        Forge.saved_user_interest(Repo, interest_id: Forge.saved_interest(Repo).id),
        Forge.saved_user_interest(Repo, interest_id: Forge.saved_interest(Repo).id)
      ]
    end

    authenticated_socket(user, "users_interests:index")
    |> handle_in(UserInterestChannel)

    assert_socket_replied_with_payload(
      "users_interests:index", %{users_interests: users_interests}
    )
  end

  test "user_interests:create replies with user interest" do
    user = Forge.saved_user(Repo)
    interest = Forge.saved_interest(Repo)
    user_interest_params = %{user_id: user.id, interest_id: interest.id}

    authenticated_socket(user, "users_interests:create")
    |> handle_in(UserInterestChannel, user_interest_params)

    user_interest = Repo.one(UserInterest)
    assert_socket_replied_with_payload("users_interests:create", user_interest)
  end

  test "user_interests:destroy replies with id of deleted interest" do
    user = Forge.saved_user(Repo)
    interest = Forge.saved_interest(Repo)
    user_interest = Forge.saved_user_interest(
      Repo,
      user_id: user.id,
      interest_id: interest.id
    )

    authenticated_socket(user, "users_interests:destroy")
    |> handle_in(UserInterestChannel, %{"id" => user_interest.id})

    assert_socket_replied_with_payload(
      "users_interests:destroy",
      %{id: user_interest.id}
    )
  end
end
