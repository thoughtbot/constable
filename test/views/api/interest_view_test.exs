defmodule ConstableWeb.Api.InterestViewTest do
  use ConstableWeb.ViewCase, async: true
  alias ConstableWeb.Api.InterestView

  test "show.json returns correct fields" do
    interest = build(:interest, id: 1)

    rendered_interest = render_one(interest, InterestView, "show.json")

    assert rendered_interest == %{
      interest: %{
        id: interest.id,
        name: interest.name,
        slack_channel: interest.slack_channel,
      }
    }
  end
end
