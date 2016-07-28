defmodule Constable.Services.SubscriptionToken do
  @token_context Constable.Endpoint
  @token_salt "subscription_token"

  def decode(token) do
    case Phoenix.Token.verify(@token_context, @token_salt, token) do
      {:ok, data} ->
        %{"user_id" => user_id, "announcement_id" => announcement_id} = data |> Poison.decode!
        {user_id, announcement_id}
      {:error, :invalid} ->
        nil
    end
  end

  def encode(subscription) do
    data = %{"user_id" => subscription.user_id, "announcement_id" => subscription.announcement_id}
    Phoenix.Token.sign(@token_context, @token_salt, data |> Poison.encode!)
  end
end
