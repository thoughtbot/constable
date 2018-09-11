defimpl Poison.Encoder, for:  Constable.User do
  alias Constable.Repo
  use ConstableWeb, :serializer

  def encode(user, _options) do
    user = user |> Repo.preload([:subscriptions, :user_interests])

    %{
      id: user.id,
      email: user.email,
      name: user.name,
      gravatar_url: gravatar_url(user.email, secure: true),
      user_interests: user.user_interests,
      subscriptions: user.subscriptions
    } |> Poison.encode!([])
  end
end
