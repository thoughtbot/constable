defmodule ConstableWeb.Api.AnnouncementController do
  use ConstableWeb, :controller

  alias Constable.Announcement
  alias Constable.Services.AnnouncementCreator
  alias Constable.Services.AnnouncementUpdater
  alias ConstableWeb.Api.AnnouncementView

  plug(Constable.Plugs.Deslugifier, slugified_key: "id")

  def index(conn, params = %{"after" => after_id}) do
    limit = Map.get(params, "page_size", 50)
    cursor = Repo.get(Announcement, after_id)

    announcements =
      Announcement
      |> where([a], a.inserted_at < ^cursor.inserted_at)
      |> order_by(desc: :inserted_at)
      |> limit(^limit)
      |> Repo.all()

    render(conn, "index.json", announcements: announcements)
  end

  def index(conn, params = %{"before" => before_id}) do
    limit = Map.get(params, "page_size", 50)
    cursor = Repo.get(Announcement, before_id)

    announcements =
      Announcement
      |> where([a], ^cursor.inserted_at < a.inserted_at)
      |> order_by(:inserted_at)
      |> limit(^limit)
      |> Repo.all()
      |> Enum.reverse()

    render(conn, "index.json", announcements: announcements)
  end

  def index(conn, params) do
    limit = Map.get(params, "page_size", 50)

    announcements =
      Announcement
      |> order_by(desc: :inserted_at)
      |> limit(^limit)
      |> Repo.all()

    render(conn, "index.json", announcements: announcements)
  end

  def create(
        conn,
        %{"announcement" => announcement_params, "interest_names" => interest_names}
      ) do
    current_user = current_user(conn)
    announcement_params = Map.put(announcement_params, "user_id", current_user.id)

    case AnnouncementCreator.create(announcement_params, interest_names) do
      {:ok, announcement} ->
        ConstableWeb.Endpoint.broadcast!(
          "update",
          "announcement:add",
          AnnouncementView.render("show.json", %{announcement: announcement})
        )

        conn
        |> put_status(:created)
        |> render("show.json", announcement: announcement)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(ConstableWeb.ChangesetView)
        |> render("error.json", changeset: changeset)
    end
  end

  def create(conn, _params), do: send_resp(conn, 422, "")

  def show(conn, %{"id" => id}) do
    announcement = Repo.get!(Announcement, id)
    render(conn, "show.json", announcement: announcement)
  end

  def update(conn, %{
        "id" => id,
        "announcement" => announcement_params,
        "interest_names" => interest_names
      }) do
    current_user = current_user(conn)
    announcement = Repo.get!(Announcement, id)

    if announcement.user_id == current_user.id do
      case AnnouncementUpdater.update(announcement, announcement_params, interest_names) do
        {:ok, announcement} ->
          ConstableWeb.Endpoint.broadcast!(
            "update",
            "announcement:update",
            AnnouncementView.render("show.json", %{announcement: announcement})
          )

          render(conn, "show.json", announcement: announcement)

        {:error, changeset} ->
          conn
          |> put_status(:unprocessable_entity)
          |> put_view(ConstableWeb.ChangesetView)
          |> render("error.json", changeset: changeset)
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

      ConstableWeb.Endpoint.broadcast!(
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
