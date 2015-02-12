defimpl ConstableApi.Serializers, for: ConstableApi.User do
  def to_json(user) do
    %{
      id: user.id,
      email: user.email,
      gravatar_url: Exgravatar.generate(user.email)
    }
  end
end
