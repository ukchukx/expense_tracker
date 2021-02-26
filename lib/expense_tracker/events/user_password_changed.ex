defmodule ExpenseTracker.Events.UserPasswordChanged do
  @moduledoc false

  @derive Jason.Encoder
  defstruct [:user_id, :password]
end
