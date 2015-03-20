defmodule Constable.Web do
  @moduledoc """
  A module that keeps using definitions for controllers,
  views and so on.

  This can be used in your application as:

      use MyApp.Web, :controller
      use MyApp.Web, :view

  Keep the definitions in this module short and clean,
  mostly focused on imports, uses and aliases.
  """

  def view do
    quote do
      use Phoenix.HTML
      use Phoenix.View, root: "web/templates"

      import Constable.Router.Helpers
    end
  end

  def controller do
    quote do
      use Phoenix.Controller

      import Constable.Router.Helpers
      alias Constable.Repo
    end
  end

  def model do
    quote do
    end
  end

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
