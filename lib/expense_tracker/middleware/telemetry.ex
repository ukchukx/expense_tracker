defmodule ExpenseTracker.Middleware.Telemetry do
  @moduledoc """
  A middleware to instrument the command dispatch pipeline with `:telemetry` events.
  It produces the following three events:
    - `[:commanded, :command, :dispatch, :start]`
    - `[:commanded, :command, :dispatch, :success]`
    - `[:commanded, :command, :dispatch, :failure]`
  """
  alias Commanded.Middleware.Pipeline

  import Pipeline

  @behaviour Commanded.Middleware

  def before_dispatch(%Pipeline{command: command, metadata: metadata} = pipeline) do
    :telemetry.execute(
      [:commanded, :command, :dispatch, :start],
      %{time: System.system_time()},
      %{command: command, metadata: metadata}
    )

    assign(pipeline, :start_time, monotonic_time())
  end

  def after_dispatch(%Pipeline{command: command, metadata: metadata} = pipeline) do
    :telemetry.execute(
      [:commanded, :command, :dispatch, :success],
      %{duration: duration(pipeline)},
      %{command: command, metadata: metadata}
    )

    pipeline
  end

  def after_failure(%Pipeline{command: command, metadata: metadata} = pipeline) do
    :telemetry.execute(
      [:commanded, :command, :dispatch, :failure],
      %{duration: duration(pipeline)},
      %{command: command, metadata: metadata}
    )

    pipeline
  end

  # Calculate the duration, in microseconds, between start time and now.
  defp duration(%Pipeline{assigns: %{start_time: start_time}}), do: monotonic_time() - start_time

  defp duration(%Pipeline{}), do: nil

  defp monotonic_time, do: System.monotonic_time(:microsecond)
end
