defmodule ConstableApi.Subscription do
  use Ecto.Model
  alias ConstableApi.Announcement
  alias ConstableApi.User

  schema "subscriptions" do
    belongs_to :user, User
    belongs_to :announcement, Announcement
    timestamps
  end
end
