defmodule ExpenseTracker.Events.UserEmailChanged do
  @derive Jason.Encoder
  defstruct [:user_id, :email]
end
