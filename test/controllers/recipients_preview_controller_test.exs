defmodule ContableWeb.RecipientsPreviewControllerTest do
  use ConstableWeb.ConnCase, async: true

  setup do
    {:ok, browser_authenticate()}
  end

  describe ".show/2" do
    test "returns the interested users' names", %{conn: conn}  do
      interest = insert(:interest)
      insert(:announcement) |> tag_with_interest(interest)
      interested_user = insert(:user) |> with_interest(interest)

      response =
        conn
        |> get(recipients_preview_path(conn, :show, %{"interests" => interest.name}))
        |> json_response(200)

      recipients_preview_html = response["recipients_preview_html"]

      assert recipients_preview_html =~ interested_user.name
    end

    test "does not return inactive users", %{conn: conn} do
      interest = insert(:interest)
      insert(:announcement) |> tag_with_interest(interest)
      interested_user = insert(:user, active: false) |> with_interest(interest)

      response =
        conn
        |> get(recipients_preview_path(conn, :show, %{"interests" => interest.name}))
        |> json_response(200)

      recipients_preview_html = response["recipients_preview_html"]

      refute recipients_preview_html =~ interested_user.name
    end
  end
end
