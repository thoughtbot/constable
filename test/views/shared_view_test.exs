defmodule Constable.SharedViewTest do
  use Constable.ConnCase
  alias Constable.SharedView

  test "markdown_with_users/1 bolds existing users" do
    create(:user, username: "joedirt")
    markdown = "Hello @joedirt not @forestgump!"

    rendered = SharedView.markdown_with_users(markdown)

    assert rendered =~ "<strong>@joedirt</strong>"
    refute rendered =~ "<strong>@forestgump</strong>"
  end
end
