defmodule Constable.HubUserValidator do
  import Ecto.Query
  alias Constable.{Repo, User}

  @ignore_users ["ralph@thoughtbot.com"]

  def disable_users_not_in(active_emails) do
    Repo.all(User.active)
    |> diff(active_emails)
    |> disable_users
  end

  defp diff(users, active_emails) do
    Enum.reject(users, fn(user) ->
      is_active = Enum.member?(active_emails, user.email)
      is_ignored = Enum.member?(@ignore_users, user.email)

      is_active || is_ignored
    end)
  end

  defp disable_users(users) do
    user_ids = users |> Enum.map(&(&1.id))

    from(u in User, where: u.id in ^user_ids)
    |> Repo.update_all(set: [active: false])
  end
end
