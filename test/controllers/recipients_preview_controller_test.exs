defmodule Constable.RecipientsPreviewControllerTest do
  use Constable.ConnCase, async: true

  setup do
    {:ok, browser_authenticate}
  end

  test "shows how many users are subscribed to the interests", %{conn: conn} do
    interests = insert_pair(:interest)
    _interested_user = insert(:user)
      |> with_interest(interests |> List.first)
      |> with_interest(interests |> List.last)
    _uninterested_user = insert(:user)

    html_result = recipient_preview_html_for(conn, interests: interests)

    assert html_result =~ "1 person is subscribed to these interests."
  end

  defp recipient_preview_html_for(conn, interests: interests) do
    json_result_for(conn, interests: interests)
    |> Map.fetch!("recipients_preview_html")
  end

  defp json_result_for(conn, interests: interests) do
    comma_separated_interests = interests |> Enum.map(&(&1.name)) |> Enum.join(",")

    get(conn, recipients_preview_path(conn, :show), interests: comma_separated_interests)
    |> json_response(200)
  end
end
