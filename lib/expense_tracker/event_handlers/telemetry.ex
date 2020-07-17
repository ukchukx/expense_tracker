defmodule ExpenseTracker.EventHandlers.Telemetry do
  @moduledoc """
  An event handler to produce `:telemetry` events for each recorded event.
  It produces the following event:
    - `[:commanded, :event, :published]`
  """
  alias ExpenseTracker.CommandedApp

  use Commanded.Event.Handler, name: __MODULE__, start_from: :current, application: CommandedApp

  def handle(event, metadata) do
    :telemetry.execute(
      [:commanded, :event, :published],
      %{timestamp: Map.get(metadata, :created_at)},
      %{event: event, metadata: metadata}
    )
  end
end
