defmodule ConstableApi.Comment do
  use Ecto.Model
  alias ConstableApi.Announcement

  schema "comments" do
    field :body

    belongs_to :announcement, Announcement
    timestamps
  end
end
