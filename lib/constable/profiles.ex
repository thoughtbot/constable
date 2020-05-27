defmodule Constable.Profiles do
  alias Constable.{User, Repo}

  def update_profile_info(user) do
    provider = Constable.Pact.get(:profile_provider)
    profile_url = provider.fetch_profile_url(user)
    image_url = provider.fetch_image_url(user)

    user
    |> User.profile_changeset(%{profile_url: profile_url, profile_image_url: image_url})
    |> Repo.update()
  end

  def update_profile_image_urls(users) do
    provider = Constable.Pact.get(:profile_provider)

    Enum.map(users, fn user ->
      image_url = provider.fetch_image_url(user)

      user
      |> User.profile_changeset(%{profile_image_url: image_url})
      |> Repo.update()
    end)

    :ok
  end
end
