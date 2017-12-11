defmodule ConstableWeb.WallabyHelper do
  use Wallaby.DSL

  def accept_all_confirm_dialogs(session) do
    execute_script(session, "window.confirm = function(m) { return true; };")
    session
  end
end
