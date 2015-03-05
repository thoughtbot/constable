defimpl Poison.Encoder, for:  Constable.User do
  def encode(user, for: :mandrill) do
    %{
      email: user.email,
      name: user.name,
      type: "bcc"
    } |> Poison.encode!
  end

  def encode(user, _options) do
    %{
      id: user.id,
      email: user.email,
      name: user.name,
      gravatar_url: Exgravatar.generate(user.email)
    } |> Poison.encode!([])
  end
end
