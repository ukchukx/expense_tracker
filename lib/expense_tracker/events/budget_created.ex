defmodule ExpenseTracker.Events.BudgetCreated do
  @moduledoc false

  @derive Jason.Encoder
  defstruct [:user_id, :budget_id, :name, :currency, :start_date, :end_date, :line_items]
end
