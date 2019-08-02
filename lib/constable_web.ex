defmodule ConstableWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, views, channels and so on.

  This can be used in your application as:

      use ConstableWeb, :controller
      use ConstableWeb, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define any helper function in modules
  and import those modules here.
  """

  def controller do
    quote do
      use Phoenix.Controller, namespace: ConstableWeb

      import Ecto.Query
      import Ecto.Schema
      import ConstableWeb.Gettext
      import ConstableWeb.ControllerHelper
      import Phoenix.LiveView.Controller, only: [live_render: 3]

      alias Constable.Repo
      alias ConstableWeb.Router.Helpers, as: Routes
    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "lib/constable_web/templates",
        namespace: ConstableWeb

      # Import convenience functions from controllers
      import Phoenix.Controller,
        only: [get_flash: 1, get_flash: 2, view_module: 1]

      import Phoenix.LiveView, only: [live_render: 2, live_render: 3, live_link: 1, live_link: 2]

      import ConstableWeb.ErrorHelpers
      import ConstableWeb.Gettext
      import ConstableWeb.SharedView
      import Constable.EnumHelper

      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      alias Constable.Repo
      alias ConstableWeb.Router.Helpers, as: Routes
    end
  end

  def router do
    quote do
      use Phoenix.Router
      use Honeybadger.Plug
      import Plug.Conn
      import Phoenix.Controller
      import Phoenix.LiveView.Router
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
      import ConstableWeb.Gettext
    end
  end

  def model do
    quote do
      use Ecto.Schema
      import Ecto.Changeset
      import Ecto.Query
      @timestamps_opts [type: :utc_datetime, usec: false]
    end
  end

  def serializer do
    quote do
      def profile_provider do
        Constable.Pact.get(:profile_provider)
      end
    end
  end

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
