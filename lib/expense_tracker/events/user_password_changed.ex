defmodule ExpenseTracker.Events.UserPasswordChanged do
  @derive Jason.Encoder
  defstruct [:user_id, :password]
end
