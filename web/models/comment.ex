defmodule ConstableApi.Comment do
  use Ecto.Model
  alias ConstableApi.Announcement
  alias ConstableApi.User

  schema "comments" do
    field :body

    belongs_to :user, User
    belongs_to :announcement, Announcement
    timestamps
  end
end
