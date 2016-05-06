defmodule Constable.PresenceValidatorTest do
  use Constable.ModelCase, async: true
  import Ecto.Changeset
  import Constable.PresenceValidator

  defmodule User do
    use Constable.Web, :model

    schema "users" do
      field :name
    end
  end

  test "is valid when there is at least one letter" do
    params = %{name: "a"}

    changeset = cast(%User{}, params, ~w(name), []) |> validate_presence(:name)

    assert changeset.errors == []
  end

  test "is invalid when the string only contains spaces" do
    params = %{name: "  "}

    changeset = cast(%User{}, params, ~w(name), []) |> validate_presence(:name)

    assert {"should not be blank", _} = changeset.errors[:name]
  end
end
