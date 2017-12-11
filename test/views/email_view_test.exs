defmodule ConstableWeb.EmailViewTest do
  use ConstableWeb.ViewCase, async: true
  alias ConstableWeb.EmailView

  test "unsubscribe_link shows a mandrill merge field" do
    assert EmailView.unsubscribe_link == "#{ConstableWeb.Endpoint.url}/unsubscribe/{{subscription_id}}"
  end

  test "notification_settings_link shows a link to the settings page" do
    assert EmailView.notification_settings_link == "#{ConstableWeb.Endpoint.url}/settings"
  end
end
