defmodule Constable.EmailViewTest do
  use Constable.ViewCase, async: true
  alias Constable.EmailView

  test "unsubscribe_link shows a mandrill merge field" do
    assert EmailView.unsubscribe_link == "#{Constable.Endpoint.url}/unsubscribe/{{subscription_id}}"
  end
end
