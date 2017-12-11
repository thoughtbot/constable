defmodule ConstableWeb.SlackChannelController do
  use Constable.Web, :controller

  alias Constable.Interest

  def edit(conn, %{"interest_id_or_name" => name}) do
    interest = find_interest(name)
    changeset = Interest.update_channel_changeset(interest, interest.slack_channel)
    render conn, "edit.html", interest: interest, changeset: changeset
  end

  def update(conn, %{"interest_id_or_name" => name, "interest" => %{"slack_channel" => channel}}) do
    interest = find_interest(name)
    case Repo.update(Interest.update_channel_changeset(interest, channel)) do
      {:ok, interest} ->
        redirect conn, to: interest_path(conn, :show, interest)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(ConstableWeb.ChangesetView, "edit.html", changeset: changeset)
    end
  end

  def delete(conn, %{"interest_id_or_name" => name}) do
    interest = find_interest(name)
    Repo.update!(Interest.changeset(interest, %{slack_channel: nil}))
    redirect conn, to: interest_path(conn, :show, interest)
  end

  defp find_interest(interest_name) do
    Repo.get_by!(Interest, name: interest_name)
  end
end
