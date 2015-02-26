defmodule Constable.Comment do
  use Ecto.Model
  alias Constable.Announcement
  alias Constable.User

  schema "comments" do
    field :body

    belongs_to :user, User
    belongs_to :announcement, Announcement
    timestamps
  end
end
