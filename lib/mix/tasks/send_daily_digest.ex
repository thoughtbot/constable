defmodule Mix.Tasks.Constable.SendDailyDigest do
  use Mix.Task
  import Ecto.Query

  def run(_) do
    Mix.Task.run "app.start"
    users = Constable.Repo.all(Constable.User)
    Constable.DailyDigest.send_email(users)
  end
end
