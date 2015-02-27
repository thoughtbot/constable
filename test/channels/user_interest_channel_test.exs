defmodule UserInterestChannelTest do
  use Constable.TestWithEcto, async: false
  import ChannelTestHelper
  import Ecto.Query
  require Forge
  alias Phoenix.Socket
  alias Constable.Repo
  alias Constable.UserInterestChannel
  alias Constable.UserInterest
  alias Constable.Serializers

  test "users_interests:index replies with user's interests" do
    user = Forge.saved_user(Repo)
    Forge.having user_id: user.id do
      users_interests = [
        Forge.saved_user_interest(Repo, interest_id: Forge.saved_interest(Repo).id),
        Forge.saved_user_interest(Repo, interest_id: Forge.saved_interest(Repo).id)
      ]
    end

    Phoenix.PubSub.subscribe(Constable.PubSub, self, "users_interests:index")
    socket_with_topic("users_interests:index")
    |> assign_current_user(user.id)
    |> handle_in_topic(UserInterestChannel)

    serialized_users_interests =
      users_interests
      |> Enum.map(&Serializers.to_json/1)
    assert_socket_replied_with_payload(
      "users_interests:index",
      %{users_interests: serialized_users_interests}
    )
  end

  test "user_interests:create replies with user interest" do
    user = Forge.saved_user(Repo)
    interest = Forge.saved_interest(Repo)
    user_interest_params = %{user_id: user.id, interest_id: interest.id}

    Phoenix.PubSub.subscribe(Constable.PubSub, self, "users_interests:create")
    socket_with_topic("users_interests:create")
    |> assign_current_user(user.id)
    |> handle_in_topic(UserInterestChannel, user_interest_params)

    user_interest = Repo.one(UserInterest) |> Serializers.to_json
    assert_socket_replied_with_payload(
      "users_interests:create",
      user_interest
    )
  end

  test "user_interests:destroy replies with id of deleted interest" do
    user = Forge.saved_user(Repo)
    interest = Forge.saved_interest(Repo)
    user_interest = Forge.saved_user_interest(
      Repo,
      user_id: user.id,
      interest_id: interest.id
    )

    Phoenix.PubSub.subscribe(Constable.PubSub, self, "users_interests:destroy")
    socket_with_topic("users_interests:destroy")
    |> assign_current_user(user.id)
    |> handle_in_topic(UserInterestChannel, %{"id" => user_interest.id})

    assert_socket_replied_with_payload(
      "users_interests:destroy",
      %{id: user_interest.id}
    )
  end
end
