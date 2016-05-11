defmodule Constable.DailyDigest do
  import Ecto.Query
  require Logger
  alias Constable.Repo
  alias Constable.Announcement
  alias Constable.Interest
  alias Constable.Mailer
  alias Constable.Emails

  @template_base "web/templates/mailers/daily_digest"

  def send_email(users, time) do
    if new_items_since?(time) do
      Logger.info "Sending daily digest"
      daily_digest_email(time, users) |> Mailer.deliver_now
    else
      Logger.info "No new items since: #{inspect time}"
    end
  end

  defp daily_digest_email(time, users) do
    Emails.daily_digest(interests_since(time), announcements_since(time), users)
  end

  defp new_items_since?(time) do
    !Enum.empty?(announcements_since(time)) || !Enum.empty?(interests_since(time))
  end

  defp interests_since(time) do
    Repo.all(from i in Interest, where: i.inserted_at > ^time)
  end

  defp announcements_since(time) do
    Repo.all(from i in Announcement, where: i.inserted_at > ^time)
    |> Repo.preload([:user, :interests])
  end
end
