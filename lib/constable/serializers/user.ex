defimpl Poison.Encoder, for: Constable.User do
  use ConstableWeb, :serializer
  alias Constable.Repo

  def encode(user, _options) do
    user = user |> Repo.preload([:subscriptions, :user_interests])

    %{
      id: user.id,
      email: user.email,
      name: user.name,
      profile_image_url: user.profile_image_url,
      user_interests: user.user_interests,
      subscriptions: user.subscriptions
    }
    |> Poison.encode!([])
  end
end
