defmodule ConstableApi.Announcement do
  use Ecto.Model
  alias ConstableApi.Comment

  schema "announcement" do
    field :title
    field :body

    has_many :comments, Comment
    timestamps
  end

  def changeset(announcement, params) do
    params
    |> cast(announcement, ~w(title body comments))
  end
end
