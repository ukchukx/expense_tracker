defmodule ExpenseTracker.Events.BudgetDeleted do
  @derive Jason.Encoder
  defstruct [:budget_id]
end
