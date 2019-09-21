defmodule ConstableWeb.LayoutView do
  use ConstableWeb, :view

  def content_container(conn, assigns \\ [], do: contents) do
    container_assigns =
      assigns
      |> Map.to_list()
      |> Keyword.put(:conn, conn)
      |> Keyword.put(:contents, contents)

    render_existing(
      assigns.view_module,
      "_content_container.html",
      container_assigns
    ) ||
      render("_content_container.html", container_assigns)
  end
end
