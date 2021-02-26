defmodule ExpenseTracker.CommandedSupervisor do
  @moduledoc false

  alias ExpenseTracker.{EventHandlers, Projectors}

  use Supervisor

  def start_link(_), do: Supervisor.start_link(__MODULE__, [], name: __MODULE__)

  def init(_arg) do
    Supervisor.init(
      [
        Projectors.User,
        Projectors.Budget,
        Projectors.ExpenseItem,
        EventHandlers.Telemetry
      ],
      strategy: :one_for_one
    )
  end
end
