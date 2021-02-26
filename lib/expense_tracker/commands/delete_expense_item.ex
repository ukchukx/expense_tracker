defmodule ExpenseTracker.Commands.DeleteExpenseItem do
  @moduledoc false

  defstruct [:expense_item_id]

  defimpl ExpenseTracker.Protocol.ValidCommand do
    alias ExpenseTracker.Validators.Uuid

    def validate(%{expense_item_id: expense_item_id} = _command) do
      expense_item_id
      |> Uuid.validate()
      |> case do
        :ok -> :ok
        {:error, err} -> [{:expense_item_id, err}]
      end
    end
  end
end
