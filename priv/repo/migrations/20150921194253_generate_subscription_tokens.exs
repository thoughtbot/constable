defmodule Constable.Repo.Migrations.GenerateSubscriptionTokens do
  use Ecto.Migration

  alias Constable.Repo

  defmodule Subscription do
    use Ecto.Schema

    schema "subscriptions" do
      field :token
    end
  end

  def up do
    subscriptions = Repo.all(Subscription)

    Enum.each(subscriptions, fn(subscription) ->
      %{subscription | token: SecureRandom.urlsafe_base64(32)}
      |> Repo.update
    end)

    alter table(:subscriptions) do
      modify :token, :string, null: false
    end

    create index(:subscriptions, [:token], %{unique: true})
  end

  def down do
    alter table(:subscriptions) do
      modify :token, :string, null: true
    end

    drop index(:subscriptions, [:token], %{unique: true})
  end
end
