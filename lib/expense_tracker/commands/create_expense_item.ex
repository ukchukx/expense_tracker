defmodule ExpenseTracker.Commands.CreateExpenseItem do
  @moduledoc false

  defstruct [:expense_item_id, :budget_id, :line_item_id, :description, :currency, :amount, :date]

  def assign_id(%__MODULE__{} = command, id), do: %__MODULE__{command | expense_item_id: id}
end

defimpl ExpenseTracker.Protocol.ValidCommand, for: ExpenseTracker.Commands.CreateExpenseItem do
  alias ExpenseTracker.Validators.{Currency, StringValidator, Uuid}

  def validate(%{expense_item_id: expense_item_id, budget_id: budget_id} = command) do
    expense_item_id
    |> validate_expense_item_id
    |> Kernel.++(validate_budget_id(budget_id))
    |> Kernel.++(validate_line_item_id(command.line_item_id))
    |> Kernel.++(validate_amount(command.amount))
    |> Kernel.++(validate_description(command.description))
    |> Kernel.++(validate_date(command.date))
    |> Kernel.++(validate_currency(command.currency))
    |> case do
      [] -> :ok
      err_list -> {:error, err_list}
    end
  end

  defp validate_expense_item_id(expense_item_id) do
    case Uuid.validate(expense_item_id) do
      :ok -> []
      {:error, err} -> [{:expense_item_id, err}]
    end
  end

  defp validate_budget_id(budget_id) do
    case Uuid.validate(budget_id) do
      :ok -> []
      {:error, err} -> [{:budget_id, err}]
    end
  end

  defp validate_line_item_id(line_item_id) do
    case Uuid.validate(line_item_id) do
      :ok -> []
      {:error, err} -> [{:line_item_id, err}]
    end
  end

  defp validate_description(nil), do: [{:description, "is not a string"}]

  defp validate_description(""), do: []

  defp validate_description(description) do
    case StringValidator.validate(description) do
      :ok -> []
      {:error, err} -> [{:description, err}]
    end
  end

  defp validate_amount(x) when is_integer(x) and x > 0, do: []

  defp validate_amount(_), do: [{:amount, "is not a valid amount"}]

  defp validate_date(nil), do: [{:date, "is not a string"}]

  defp validate_date(""), do: [{:date, "cannot be empty"}]

  defp validate_date(date) do
    case Date.from_iso8601(date) do
      {:ok, _valid_date} -> []
      _ -> [{:date, "is not a valid date"}]
    end
  end

  defp validate_currency(""), do: [{:currency, "is empty"}]

  defp validate_currency(nil), do: [{:currency, "is not a string"}]

  defp validate_currency(currency) do
    case Currency.validate(currency) do
      :ok -> []
      {:error, err} -> [{:currency, err}]
    end
  end

end
