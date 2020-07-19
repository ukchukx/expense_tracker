defmodule ExpenseTracker.Events.ExpenseItemDeleted do
  @derive Jason.Encoder
  defstruct [:expense_item_id]
end
