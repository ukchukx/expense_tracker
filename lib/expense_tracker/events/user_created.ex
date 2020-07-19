defmodule ExpenseTracker.Events.UserCreated do
  @derive Jason.Encoder
  defstruct [:user_id, :email, :active, :password]
end
