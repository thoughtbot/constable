defimpl Poison.Encoder, for:  Constable.User do
  alias Constable.Repo

  def encode(user, _options) do
    user = user |> Repo.preload([:subscriptions, :user_interests])

    %{
      id: user.id,
      email: user.email,
      name: user.name,
      gravatar_url: Exgravatar.generate(user.email, %{}, true),
      user_interests: user.user_interests,
      subscriptions: user.subscriptions
    } |> Poison.encode!([])
  end
end
