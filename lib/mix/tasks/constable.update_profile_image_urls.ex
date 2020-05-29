defmodule Mix.Tasks.Constable.UpdateProfileImageUrls do
  use Mix.Task

  import Ecto.Query, only: [where: 3]

  require Logger

  alias Constable.{User, Repo, Profiles}

  @moduledoc """
  Fetches all user's image urls from hub and updates the user's profile_image_url.

  ## Sample use

    mix constable.update_profile_image_urls
  """

  @doc "Fetches and updates all users' image urls (from hub)"
  def run(_) do
    Mix.Task.run("app.start")

    users =
      User
      |> where([u], u.active == true)
      |> where([u], is_nil(u.profile_image_url))
      |> Repo.all()

    Logger.info("""
    Active users without a valid profile_image_url

    #{inspect(Enum.map(users, & &1.email))}
    """)

    Profiles.update_profile_image_urls(users)
  end
end
