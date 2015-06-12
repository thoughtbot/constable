defmodule Constable.Mandrill do
  require Logger
  alias Constable.Serializers

  @mandrill_url "https://mandrillapp.com/api/1.0/messages/send.json"

  def message_send(message_params) do
    params = %{
      key: System.get_env("MANDRILL_KEY"),
      message: message_params
    } |> Poison.encode!

    Task.async(fn ->
      Logger.info "Sending email with params:"
      Logger.info inspect(params)
      HTTPoison.post(@mandrill_url, params) |> inspect |> Logger.info
    end)
  end

  def format_users(users) do
    Enum.map(users, fn(user) ->
      %{
        email: user.email,
        name: user.name,
        type: "bcc"
      }
    end)
  end
end
