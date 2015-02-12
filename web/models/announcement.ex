defmodule ConstableApi.Announcement do
  use Ecto.Model
  alias ConstableApi.Comment
  alias ConstableApi.User

  schema "announcement" do
    field :title
    field :body

    belongs_to :user, User
    has_many :comments, Comment
    timestamps
  end
end
