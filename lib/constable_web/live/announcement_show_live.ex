defmodule ConstableWeb.AnnouncementShowLive do
  use ConstableWeb, :live_view

  alias Constable.{Announcement, Comment, PubSub, Repo, Subscription, User}
  alias Constable.Services.CommentCreator

  def render(assigns) do
    Phoenix.View.render(ConstableWeb.AnnouncementView, "show.html", assigns)
  end

  def mount(_, %{"id" => id, "current_user_id" => user_id}, socket) do
    announcement = Repo.get!(Announcement.with_announcement_list_assocs(), id)
    if connected?(socket), do: PubSub.subscribe_to_announcement(announcement)
    comment = Comment.create_changeset(%{})
    current_user = Repo.get(User.active(), user_id)

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
    %{announcement: announcement, current_user: current_user} = socket.assigns

    comment_params =
      params
      |> Map.put("user_id", current_user.id)
      |> Map.put("announcement_id", announcement.id)

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

  def handle_info({:new_comment, comment}, socket) do
    socket
    |> update(:comments, fn comments -> comments ++ [comment] end)
    |> noreply()
  end

  defp get_subscription(announcement, user) do
    Repo.get_by(Subscription,
      announcement_id: announcement.id,
      user_id: user.id
    )
  end

  defp noreply(socket), do: {:noreply, socket}
end
