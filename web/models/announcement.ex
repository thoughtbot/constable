defmodule ConstableApi.Announcement do
  use Ecto.Model

  schema "announcement" do
    field :title
    field :body

    timestamps
  end
end
