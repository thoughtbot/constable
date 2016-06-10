defmodule Mix.Tasks.Constable.DisableInactivePeople do
  use Mix.Task

  alias Constable.{Hub, HubUserValidator}

  def run(_opts) do
    Mix.Task.run "app.start"

    active_people_emails = Hub.active_people_emails
    HubUserValidator.disable_users_not_in(active_people_emails)
  end
end
