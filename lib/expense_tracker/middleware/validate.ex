defmodule ExpenseTracker.Middleware.Validate do
  alias ExpenseTracker.Protocol.ValidCommand
  alias Commanded.Middleware.Pipeline

  import Pipeline

  @behaviour Commanded.Middleware

  def before_dispatch(%{command: command} = pipeline) do
    case ValidCommand.validate(command) do
      :ok ->
        pipeline

      {:error, errors} ->
        pipeline |> respond({:error, :validation_failure, merge_errors(errors)}) |> halt
    end
  end

  def after_dispatch(pipeline), do: pipeline

  def after_failure(pipeline), do: pipeline

  defp merge_errors(errors) do
    errors
    |> Enum.group_by(
      fn {field, _message} -> field end,
      fn {_field, message} -> message end
    )
    |> Map.new()
  end
end
