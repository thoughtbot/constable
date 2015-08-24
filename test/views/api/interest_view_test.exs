defmodule Constable.Api.InterestViewTest do
  use Constable.ViewCase, async: true
  alias Constable.Api.InterestView

  test "show.json returns correct fields" do
    interest = Forge.interest

    rendered_interest = render_one(interest, InterestView, "show.json")

    assert rendered_interest == %{
      data: %{
        id: interest.id,
        name: interest.name,
      }
    }
  end
end
