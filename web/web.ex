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
      alias Constable.Repo

      import Constable.Router.Helpers

      def pluck(enumerable, property) do
        Enum.map(enumerable, fn(object) ->
          Map.get(object, property)
        end)
      end
    end
  end

  def controller do
    quote do
      use Phoenix.Controller

      import Constable.Router.Helpers
      import Ecto.Query
      import Ecto.Model

      alias Constable.Repo

      def unauthorized(conn) do
        send_resp(conn, 401, "")
      end

      def current_user(conn) do
        conn.assigns[:current_user]
      end
    end
  end

  def model do
    quote do
      use Ecto.Model
      import Constable.PresenceValidator
    end
  end

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
