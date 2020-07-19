defmodule ExpenseTracker.Middleware.Uniqueness do
  alias ExpenseTracker.Protocol.UniqueFields
  alias Commanded.Middleware.Pipeline

  import Pipeline

  @behaviour Commanded.Middleware

  def before_dispatch(%{command: command} = pipeline) do
    case UniqueFields.unique(command) do
      :ok -> pipeline
      {:error, errors} -> pipeline |> respond({:error, :uniqueness_failure, errors}) |> halt
    end
  end

  def after_dispatch(pipeline), do: pipeline

  def after_failure(pipeline), do: pipeline
end
