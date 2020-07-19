defmodule ExpenseTracker.Events.UserDisabled do
  @derive Jason.Encoder
  defstruct [:user_id]
end
