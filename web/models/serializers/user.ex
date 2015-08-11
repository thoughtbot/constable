defimpl Poison.Encoder, for:  Constable.User do
  def encode(user, _options) do
    %{
      id: user.id,
      email: user.email,
      name: user.name,
      gravatar_url: Exgravatar.generate(user.email),
      user_interests: user.user_interests,
      subscriptions: user.subscriptions
    } |> Poison.encode!([])
  end
end
