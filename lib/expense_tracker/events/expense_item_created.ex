defmodule ExpenseTracker.Events.ExpenseItemCreated do
  @derive Jason.Encoder
  defstruct [:expense_item_id, :budget_id, :description, :amount]
end
