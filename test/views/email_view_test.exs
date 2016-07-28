defmodule Constable.EmailViewTest do
  use Constable.ViewCase, async: true
  alias Constable.EmailView

  test "unsubscribe_link shows a mandrill merge field" do
    assert EmailView.unsubscribe_link == "#{Constable.Endpoint.url}/v2/unsubscribe/{{subscription_id}}"
  end

  test "notification_settings_link shows a link to the settings page" do
    assert EmailView.notification_settings_link == "#{Constable.Endpoint.url}/settings"
  end
end
