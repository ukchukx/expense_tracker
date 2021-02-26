defmodule ExpenseTracker.Events.ExpenseItemDeleted do
  @moduledoc false

  @derive Jason.Encoder
  defstruct [:expense_item_id]
end
