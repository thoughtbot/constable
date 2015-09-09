defmodule Mix.Tasks.Constable.SendDailyDigest do
  use Mix.Task
  import Ecto.Query

  alias Constable.Repo
  alias Constable.User

  def run(_) do
    Mix.Task.run "app.start"
    users = Repo.all(from u in User, where: u.daily_digest == true)
    Pact.get(:daily_digest).send_email(users)
  end
end
