defmodule Constable.PresenceValidator do
  import Ecto.Changeset

  def validate_presence(changeset, field) do
    changeset
    |> update_change(field, &String.strip/1)
    |> validate_length(field, min: 1, message: "should not be blank")
  end
end
