defimpl ConstableApi.Serializers, for: ConstableApi.User do
  def to_json(user) do
    %{
      id: user.id,
      email: user.email,
      name: user.name,
      gravatar_url: Exgravatar.generate(user.email)
    }
  end

  def to_json(user, :mandrill) do
    %{
      email: user.email,
      name: user.name,
      type: "bcc"
    }
  end
end
