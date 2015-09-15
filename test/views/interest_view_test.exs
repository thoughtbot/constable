defmodule Constable.InterestViewTest do
  use Constable.ViewCase
  alias Constable.InterestView

  test "show.json returns json with id and name" do
    interest = create(:interest)

    rendered_interest = render_one(interest, InterestView, "show.json")

    assert rendered_interest == %{
      id: interest.id,
      name: interest.name
    }
  end

  test "name.json return just the name" do
    interest = create(:interest)

    rendered_interest = render_one(interest, InterestView, "name.json")

    assert rendered_interest == interest.name
  end
end
