defmodule Constable.InterestViewTest do
  use Constable.ViewCase, async: true

  test "show.json returns json with id and name" do
    interest = Forge.interest

    rendered_interest = render_one(interest, "show.json")

    assert rendered_interest == %{
      id: interest.id,
      name: interest.name
    }
  end

  test "name.json return just the name" do
    interest = Forge.interest

    rendered_interest = render_one(interest, "name.json")

    assert rendered_interest == interest.name
  end
end
