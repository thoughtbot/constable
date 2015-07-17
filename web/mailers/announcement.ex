defmodule Constable.Mailers.Announcement do
  alias Constable.User
  alias Constable.Repo
  alias Constable.Mandrill
  import Constable.Mailers.Base

  @template_base "web/templates/mailers/announcements"
  @tags ~w(new-announcement)

  def created(announcement) do
    default_attributes(announcement: announcement, author: announcement.user)
    |> Map.merge(%{
      to: interested_users(announcement),
      subject: announcement.title,
      tags: @tags,
      html: email_html(announcement)
    })
    |> Pact.get(:mailer).message_send
  end

  defp email_html(announcement) do
    render_template("new",
      announcement: announcement,
      interests: interest_names(announcement),
      author: announcement.user,
      author_avatar_url: Exgravatar.generate(announcement.user.email)
    )
  end

  defp interested_users(announcement) do
    announcement
    |> Map.get(:interested_users)
    |> Mandrill.format_users
  end

  def interest_names(announcement) do
    announcement
    |> Repo.preload(:interests)
    |> Map.get(:interests)
    |> Enum.map(&("##{&1.name}"))
    |> Enum.join(", ")
  end

  defp render_template(path, bindings) do
    bindings = Dict.merge(default_bindings, bindings)
    EEx.eval_file("#{@template_base}/#{path}.eex", bindings)
  end
end
