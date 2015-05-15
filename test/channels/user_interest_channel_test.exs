defmodule UserInterestChannelTest do
  use Constable.ChannelCase
  require Forge
  alias Constable.UserInterestChannel
  alias Constable.UserInterest

  @channel UserInterestChannel

  test "'all' replies with user's interests" do
    user = Forge.saved_user(Repo)
    Forge.having user_id: user.id do
      users_interests = [
        Forge.saved_user_interest(Repo, interest_id: Forge.saved_interest(Repo).id),
        Forge.saved_user_interest(Repo, interest_id: Forge.saved_interest(Repo).id)
      ]
    end

    ref = join!("user_interests", %{"token" => user.token})
    |> push("all")

    payload = payload_from_reply(ref, :ok)
    assert payload == %{user_interests: users_interests}
  end

  test "'create' replies with the new user interest" do
    user = Forge.saved_user(Repo)
    interest = Forge.saved_interest(Repo)
    user_interest_params = %{user_id: user.id, interest_id: interest.id}

    ref = join!("user_interests", %{"token" => user.token})
    |> push("create", user_interest_params)

    payload = payload_from_reply(ref, :ok)
    user_interest = Repo.one(UserInterest)
    assert payload == %{user_interest: user_interest}
  end

  test "'destroy' replies with the id of deleted interest" do
    user = Forge.saved_user(Repo)
    interest = Forge.saved_interest(Repo)
    user_interest = Forge.saved_user_interest(
      Repo,
      user_id: user.id,
      interest_id: interest.id
    )

    ref = join!("user_interests", %{"token" => user.token})
    |> push("destroy", %{"id" => user_interest.id})

    payload = payload_from_reply(ref, :ok)
    assert payload == %{id: user_interest.id}
  end
end
