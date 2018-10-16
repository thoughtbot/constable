defmodule ConstableWeb.UserManagesInterestsTest do
  use ConstableWeb.AcceptanceCase

  @unsubscribe_link_css css("[data-role=unsubscribe-from-interest]")
  @subscribe_link_css css("[data-role=subscribe-to-interest]")
  @view_all_interests_css css("[data-role=view-all-interests]")

  test "user manages interests", %{session: session} do
    insert(:interest)

    session |> view_interests
    assert not_subscribed_to_interest?(session)

    session |> subscribe_to_interest
    assert subscribed_to_interest?(session)

    session |> unsubscribe_from_interest
    assert not_subscribed_to_interest?(session)
  end

  test "user subscribes to an interest from interest page", %{session: session} do
    user = insert(:user)
    interest = insert(:interest)
    session |> visit(Routes.interest_path(Endpoint, :show, interest, as: user.id))

    assert not_subscribed_to_interest?(session)
    session |> subscribe_to_interest

    assert subscribed_to_interest?(session)
  end

  defp view_interests(session) do
    user = insert(:user)

    session
    |> visit(Routes.announcement_path(Endpoint, :index, as: user.id))
    |> click(@view_all_interests_css)
  end

  defp subscribed_to_interest?(session) do
    session |> has?(@unsubscribe_link_css)
  end

  defp not_subscribed_to_interest?(session) do
    session |> has?(@subscribe_link_css)
  end

  defp subscribe_to_interest(session) do
    session |> click(@subscribe_link_css)
  end

  defp unsubscribe_from_interest(session) do
    session |> click(@unsubscribe_link_css)
  end
end
