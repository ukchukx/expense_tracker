defmodule ExpenseTracker.Events.ExpenseItemCreated do
  @moduledoc false

  @derive Jason.Encoder
  defstruct [:expense_item_id, :budget_id, :line_item_id, :description, :currency, :amount, :date]
end
