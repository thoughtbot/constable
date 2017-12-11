defmodule ConstableWeb.SharedViewTest do
  use ConstableWeb.ConnCase
  alias ConstableWeb.SharedView

  test "markdown_with_users/1 bolds existing users" do
    insert(:user, username: "joedirt")
    markdown = "Hello @joedirt not @forestgump!"

    rendered = SharedView.markdown_with_users(markdown)

    assert rendered =~ "<strong>@joedirt</strong>"
    refute rendered =~ "<strong>@forestgump</strong>"
  end
end
