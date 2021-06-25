defmodule ConstableWeb.AnnouncementLive.Show do
  use ConstableWeb, :live_view

  alias Constable.{Announcement, Comment, PubSub, Repo, Subscription, User}
  alias Constable.Services.CommentCreator

  def render(assigns) do
    Phoenix.View.render(ConstableWeb.AnnouncementView, "show.html", assigns)
  end

  def mount(%{"id" => id}, session, socket) when is_binary(id) do
    id = Constable.Slug.deslugify!(id)
    mount(%{"id" => id}, session, socket)
  end

  def mount(%{"id" => id}, session, socket) do
    if connected?(socket), do: PubSub.subscribe_to_announcement(id)
    announcement = Repo.get!(Announcement.with_announcement_list_assocs(), id)
    comment = Comment.create_changeset(%{})
    current_user = Repo.get(User.active(), session["current_user_id"])

    socket =
      assign(socket,
        announcement: announcement,
        comments: announcement.comments,
        comment_changeset: comment,
        subscription: get_subscription(announcement, current_user),
        users: Repo.all(User.active()),
        current_user: current_user,
        page_title: announcement.title
      )

    {:ok, socket}
  end

  def handle_event("create-comment", %{"comment" => params}, socket) do
    params |> Map.get("body") |> create_comment(socket)
  end

  def handle_event("keydown", event, socket) do
    if event["key"] == "Enter" && (event["metaKey"] || event["ctrlKey"]) do
      event |> Map.get("value") |> create_comment(socket)
    else
      {:noreply, socket}
    end
  end

  def handle_info({:new_comment, comment}, socket) do
    socket
    |> update(:comments, fn comments -> comments ++ [comment] end)
    |> noreply()
  end

  defp create_comment(body, socket) do
    %{announcement: announcement, current_user: current_user} = socket.assigns

    comment_params = %{
      "body" => body,
      "user_id" => current_user.id,
      "announcement_id" => announcement.id
    }

    case CommentCreator.create(comment_params) do
      {:ok, _comment} ->
        socket
        |> assign(:comment_changeset, Comment.create_changeset(%{}))
        |> assign(:subscription, get_subscription(announcement, current_user))
        |> noreply()

      {:error, changeset} ->
        socket
        |> put_flash(:error, gettext("Comment was invalid"))
        |> assign(:comment_changeset, changeset)
        |> noreply()
    end
  end

  defp get_subscription(announcement, user) do
    Repo.get_by(Subscription,
      announcement_id: announcement.id,
      user_id: user.id
    )
  end

  defp noreply(socket), do: {:noreply, socket}
end
