defmodule Constable.Env do
  @doc """
  Gets a variable from the environment and throws an error if it does not exist
  """
  def get(key) do
    System.get_env() |> Map.fetch!(key)
  end
end
