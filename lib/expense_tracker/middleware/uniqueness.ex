defmodule ExpenseTracker.Middleware.Uniqueness do
  @moduledoc false

  alias Commanded.Middleware.Pipeline
  alias ExpenseTracker.Protocol.UniqueFields

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
