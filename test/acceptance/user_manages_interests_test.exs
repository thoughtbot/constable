defmodule Constable.UserManagesInterestsTest do
  use Constable.AcceptanceCase

  test "user manages interests", %{session: session} do
    interest_everyone = create(:interest, name: "Everyone")
    interest_design = create(:interest, name: "Design")

    session |> view_interests

    assert not_subscribed_to?(session, interest_everyone)
    assert not_subscribed_to?(session, interest_design)

    session |> subscribe_to(interest_everyone)

    assert subscribed_to?(session, interest_everyone)
    assert not_subscribed_to?(session, interest_design)

    session |> unsubscribe_from(interest_everyone)

    assert not_subscribed_to?(session, interest_everyone)
    assert not_subscribed_to?(session, interest_design)
  end

  defp view_interests(session, user \\ create(:user)) do
    session
    |> visit(announcement_path(Endpoint, :index, as: user.id))
    |> click("[data-role=view-all-interests]")
  end

  defp subscribed_to?(session, interest) do
    session
    |> find_interest(interest)
    |> has_css?("[data-role=unsubscribe-from-interest]")
  end

  defp not_subscribed_to?(session, interest) do
    session
    |> find_interest(interest)
    |> has_css?("[data-role=subscribe-to-interest]")
  end

  defp subscribe_to(session, interest) do
    session
    |> find_interest(interest)
    |> click("[data-role='subscribe-to-interest']")
  end

  defp unsubscribe_from(session, interest) do
    session
    |> find_interest(interest)
    |> click("[data-role='unsubscribe-from-interest']")
  end

  defp find_interest(session, interest) do
    session
    |> find(".interest-list-item[data-id='#{interest.id}']")
  end
end
