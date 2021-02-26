defmodule ExpenseTracker.Commands do
  @moduledoc false

  alias ExpenseTracker.CommandedApp

  def dispatch(command, opts \\ []) do
    CommandedApp.dispatch(
      command,
      opts ++ [returning: :aggregate_state, consistency: Keyword.get(opts, :consistency, :strong)]
    )
  end
end
