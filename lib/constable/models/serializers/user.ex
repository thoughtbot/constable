defimpl Poison.Encoder, for:  Constable.User do
  alias Constable.Repo
  alias Constable.Services.HubProfile
  use ConstableWeb, :serializer

  def encode(user, _options) do
    user = user |> Repo.preload([:subscriptions, :user_interests])

    %{
      id: user.id,
      email: user.email,
      name: user.name,
      profile_image_url: HubProfile.image_url(user),
      user_interests: user.user_interests,
      subscriptions: user.subscriptions
    } |> Poison.encode!([])
  end
end
