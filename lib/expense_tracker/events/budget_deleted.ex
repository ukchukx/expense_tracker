defmodule ExpenseTracker.Events.BudgetDeleted do
  @moduledoc false

  @derive Jason.Encoder
  defstruct [:budget_id]
end
