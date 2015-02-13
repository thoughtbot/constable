defmodule ConstableApi.Mandrill do
  alias ConstableApi.Serializers

  @mandrill_url "https://mandrillapp.com/api/1.0/messages/send.json"

  def message_send(message_params) do
    params = %{
      key: System.get_env("MANDRILL_KEY"),
      message: message_params
    } |> Poison.encode!
    HTTPoison.post!(@mandrill_url, params).body
  end

  def format_users(users), do: Enum.map(users, &format_user/1)
  def format_user(user), do: Serializers.to_json(user, :mandrill)
end

