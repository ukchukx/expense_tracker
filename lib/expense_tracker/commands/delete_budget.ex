defmodule ExpenseTracker.Commands.DeleteBudget do
  defstruct [:budget_id]

  defimpl ExpenseTracker.Protocol.ValidCommand do
    alias ExpenseTracker.Validators.Uuid

    def validate(%{budget_id: budget_id} = _command) do
      budget_id
      |> Uuid.validate
      |> case do
        :ok           -> :ok
        {:error, err} -> [{:budget_id, err}]
      end
    end
  end
end
