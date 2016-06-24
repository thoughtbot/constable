defmodule Constable.Api.AnnouncementController do
  use Constable.Web, :controller

  alias Constable.Announcement
  alias Constable.AnnouncementForm
  alias Constable.Services.AnnouncementSubscriber
  alias Constable.Services.AnnouncementUpdater
  alias Constable.Services.SlackHook
  alias Constable.Api.AnnouncementView

  plug :scrub_params, "announcement" when action in [:create, :update]

  def index(conn, _params) do
    announcements = Repo.all(Announcement)
    render(conn, "index.json", announcements: announcements)
  end

  def create(conn,
      %{"announcement" => announcement_params, "interest_names" => interest_names}) do
    current_user = current_user(conn)
    announcement_params = announcement_params
      |> Map.put("user_id", current_user.id)
      |> Map.put("interests", interest_names |> Enum.join(","))

    changeset = AnnouncementForm.changeset(announcement_params)

    if changeset.valid? do
      multi = AnnouncementForm.create(changeset, current_user)
      case Repo.transaction(multi) do
        {:ok, %{announcement: announcement}} ->
          conn
          |> put_status(:created)
          |> render("show.json", announcement: announcement)
      {:error, _failure, _changes} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Constable.ChangesetView, "error.json", changeset: changeset)
      end
    else
      conn
      |> put_status(:unprocessable_entity)
      |> render(Constable.ChangesetView, "error.json", changeset: changeset)
    end
  end
  def create(conn, _params), do: send_resp(conn, 422, "")

  def show(conn, %{"id" => id}) do
    announcement = Repo.get!(Announcement, id)
    render conn, "show.json", announcement: announcement
  end

  def update(conn, %{
      "id" => id, "announcement" => announcement_params,
      "interest_names" => interest_names
    }) do

    current_user = current_user(conn)
    announcement = Repo.get!(Announcement, id)

    if announcement.user_id == current_user.id do
      case AnnouncementUpdater.update(announcement, announcement_params, interest_names) do
        {:ok, announcement} ->
          Constable.Endpoint.broadcast!(
            "update",
            "announcement:update", 
            AnnouncementView.render("show.json", %{announcement: announcement})
          )
          render(conn, "show.json", announcement: announcement)
        {:error, changeset} ->
          conn
          |> put_status(:unprocessable_entity)
          |> render(Constable.ChangesetView, "error.json", changeset: changeset)
      end
    else
      unauthorized(conn)
    end
  end
  def update(conn, _params), do: send_resp(conn, 422, "")

  def delete(conn, %{"id" => id}) do
    current_user = current_user(conn)
    announcement = Repo.get!(Announcement, id)

    if announcement.user_id == current_user.id do
      Repo.delete!(announcement)
      Constable.Endpoint.broadcast!(
        "update",
        "announcement:remove",
        %{id: announcement.id}
      )
      send_resp(conn, 204, "")
    else
      unauthorized(conn)
    end
  end
end
