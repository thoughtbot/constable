defmodule Mix.Tasks.Constable.SendDailyDigest do
  use Mix.Task
  import Ecto.Query
  require Logger

  alias Constable.Repo
  alias Constable.User

  def run(_) do
    Mix.Task.run "app.start"
    users = Repo.all(from u in User.active, where: u.daily_digest == true)
    user_emails = for user <- users do
      user.email
    end
    Logger.info """
    Users with Daily Digest enabled:

    #{inspect user_emails}
    """
    since = Constable.Time.yesterday
    Constable.DailyDigest.send_email(users, since)
  end
end
