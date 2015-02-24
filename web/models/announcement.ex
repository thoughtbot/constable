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

  def changeset(announcement, :update, params \\ nil) do
    params
    |> cast(announcement, ~w{}, ~w{title body})
  end
end
