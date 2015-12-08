defmodule Constable.Mailers.Announcement do
  alias Constable.Repo
  alias Constable.Mandrill
  import Constable.Mailers.Base

  @template_base "web/templates/mailers/announcements"
  @tags ~w(new-announcement)

  def created(announcement, users) do
    announcement = announcement |> Repo.preload([:user, :interests])
    default_attributes(author: announcement.user)
    |> Map.merge(%{
      to: Mandrill.format_users(users),
      subject: announcement.title,
      tags: @tags,
      html: created_html(announcement),
      text: created_text(announcement),
      headers: %{
        "Message-ID" => announcement_message_id(announcement)
      }
    })
    |> reply_to(announcement_email_address(announcement))
    |> Pact.get(:mailer).message_send
  end

  def mentioned(announcement, users) do
    announcement = announcement |> Repo.preload([:user, :interests])
    default_attributes(author: announcement.user)
    |> Map.merge(%{
      to: Mandrill.format_users(users),
      subject: "You were mentioned in: #{announcement.title}",
      tags: @tags,
      html: mentioned_html(announcement),
      text: mentioned_text(announcement),
      headers: %{
        "Message-ID" => announcement_message_id(announcement)
      }
    })
    |> reply_to(announcement_email_address(announcement))
    |> Pact.get(:mailer).message_send
  end

  defp created_text(announcement) do
    render_template("new.text",
      announcement: announcement,
      interests: interest_names(announcement),
      author: announcement.user,
    )
  end

  defp created_html(announcement) do
    render_template("new.html",
      announcement: announcement,
      interests: interest_names(announcement),
      author: announcement.user,
      author_avatar_url: Exgravatar.generate(announcement.user.email)
    )
  end

  defp mentioned_html(announcement) do
    render_template("mentioned.html",
      announcement: announcement,
      interests: interest_names(announcement),
      author: announcement.user,
      author_avatar_url: Exgravatar.generate(announcement.user.email)
    )
  end

  defp mentioned_text(announcement) do
    render_template("mentioned.text",
      announcement: announcement,
      interests: interest_names(announcement),
      author: announcement.user,
    )
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
