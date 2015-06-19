defmodule Constable.CommentView do
  use Constable.Web, :view

  @attributes ~W(id body user announcement_id inserted_at)a

  def render("show.json", %{comment: comment}) do
    comment |> Map.take(@attributes)
  end
end
