defmodule Constable.Mandrill do
  alias Constable.Serializers

  @mandrill_url "https://mandrillapp.com/api/1.0/messages/send.json"

  def message_send(message_params) do
    params = %{
      key: System.get_env("MANDRILL_KEY"),
      message: message_params
    } |> Poison.encode!

    spawn(fn ->
      HTTPoison.post!(@mandrill_url, params).body
    end)
  end

  def format_users(users), do: Poison.encode!(users, for: :mandrill)
end
