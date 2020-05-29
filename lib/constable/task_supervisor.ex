defmodule Constable.TaskSupervisor do
  def one_off_task(function_to_perform) do
    Task.Supervisor.start_child(__MODULE__, function_to_perform)
  end
end
