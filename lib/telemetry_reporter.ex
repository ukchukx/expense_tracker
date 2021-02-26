defmodule ExpenseTracker.TelemetryReporter do
  require Logger

  def setup do
    events = [
      [:commanded, :command, :dispatch, :start],
      [:commanded, :command, :dispatch, :success],
      [:commanded, :command, :dispatch, :failure],
      [:commanded, :event, :published]
    ]

    :telemetry.attach_many("telemetry_reporter", events, &__MODULE__.handle_event/4, nil)
  end

  def handle_event(
        [:commanded, :command, :dispatch, :start],
        _measurements,
        %{command: command} = _metadata,
        nil
      ) do
    Logger.debug("Command #{inspect(command.__struct__)} dispatched")
  end

  def handle_event(
        [:commanded, :command, :dispatch, :success],
        %{duration: duration} = _measurements,
        %{command: command} = _metadata,
        nil
      ) do
    Logger.debug("Command #{inspect(command.__struct__)} succeeded in #{duration / 1000} ms")
  end

  def handle_event(
        [:commanded, :command, :dispatch, :failure],
        _measurements,
        %{command: command} = _metadata,
        nil
      ) do
    Logger.debug("Command #{inspect(command.__struct__)} failed")
  end

  def handle_event(
        [:commanded, :event, :published],
        %{timestamp: timestamp} = _measurements,
        %{event: event} = _metadata,
        nil
      ) do
    Logger.debug("Event #{inspect(event.__struct__)} published at #{timestamp}")
  end
end
