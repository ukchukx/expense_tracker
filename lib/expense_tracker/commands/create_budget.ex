defmodule ExpenseTracker.Commands.CreateBudget do
  @moduledoc false

  defstruct [:user_id, :budget_id, :name, :start_date, :end_date, :line_items]

  @unbudgeted_description "Unbudgeted"

  def assign_id(%__MODULE__{} = command, id), do: %__MODULE__{command | budget_id: id}

  def add_un_budgeted_item(%__MODULE__{line_items: line_items} = command) do
    line_items =
      case Enum.any?(line_items, &(&1.description == @unbudgeted_description)) do
        false ->
          List.insert_at(line_items, -1, %{
            amount: 0,
            description: @unbudgeted_description,
            id: Ecto.UUID.generate()
          })

        true ->
          line_items
      end

    %{command | line_items: line_items}
  end
end

defimpl ExpenseTracker.Protocol.ValidCommand, for: ExpenseTracker.Commands.CreateBudget do
  alias ExpenseTracker.Validators.{LineItemsValidator, StringValidator, Uuid}

  def validate(%{user_id: user_id, budget_id: budget_id} = command) do
    user_id
    |> validate_user_id
    |> Kernel.++(validate_budget_id(budget_id))
    |> Kernel.++(validate_start_date(command.start_date))
    |> Kernel.++(validate_end_date(command.end_date))
    |> Kernel.++(validate_line_items(command.line_items))
    |> Kernel.++(validate_name(command.name))
    |> case do
      [] -> :ok
      err_list -> {:error, err_list}
    end
  end

  defp validate_user_id(user_id) do
    case Uuid.validate(user_id) do
      :ok -> []
      {:error, err} -> [{:user_id, err}]
    end
  end

  defp validate_budget_id(budget_id) do
    case Uuid.validate(budget_id) do
      :ok -> []
      {:error, err} -> [{:budget_id, err}]
    end
  end

  defp validate_line_items([]), do: []

  defp validate_line_items(nil), do: [{:line_items, "is not a list"}]

  defp validate_line_items(line_items) do
    case LineItemsValidator.validate(line_items) do
      :ok -> []
      {:error, err} -> [{:line_items, err}]
    end
  end

  defp validate_name(""), do: [{:name, "is empty"}]

  defp validate_name(nil), do: [{:name, "is not a string"}]

  defp validate_name(name) do
    case StringValidator.validate(name) do
      :ok -> []
      {:error, err} -> [{:name, err}]
    end
  end

  defp validate_start_date(%Date{}), do: []

  defp validate_start_date(_), do: [{:start_date, "is not a date"}]

  defp validate_end_date(%Date{}), do: []

  defp validate_end_date(_), do: [{:end_date, "is not a date"}]
end
