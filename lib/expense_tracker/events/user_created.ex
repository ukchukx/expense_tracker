defmodule ExpenseTracker.Events.UserCreated do
  @moduledoc false

  @derive Jason.Encoder
  defstruct [:user_id, :email, :active, :password]
end
