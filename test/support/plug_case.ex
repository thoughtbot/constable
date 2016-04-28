defmodule Constable.PlugCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      use Phoenix.ConnTest
    end
  end
end
