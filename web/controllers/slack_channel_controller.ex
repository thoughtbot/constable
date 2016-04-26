defmodule Constable.SlackChannelController do
  use Constable.Web, :controller

  alias Constable.Interest

  def edit(conn, %{"interest_id" => id}) do
    interest = Repo.get!(Interest.with_announcements, id)
    changeset = Interest.update_channel_changeset(interest, interest.slack_channel)
    render conn, "edit.html", interest: interest, changeset: changeset
  end

  def update(conn, %{"interest_id" => id, "interest" => %{"slack_channel" => channel}}) do
    interest = Repo.get!(Interest.with_announcements, id)
    case Repo.update(Interest.update_channel_changeset(interest, channel)) do
      {:ok, interest} ->
        redirect conn, to: interest_path(conn, :show, interest)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Constable.ChangesetView, "edit.html", changeset: changeset)
    end
  end

  def delete(conn, %{"interest_id" => id}) do
    interest = Repo.get!(Interest, id)
    Repo.update!(Interest.changeset(interest, %{slack_channel: nil}))
    redirect conn, to: interest_path(conn, :show, interest)
  end
end
