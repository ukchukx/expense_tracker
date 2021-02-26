defmodule ExpenseTracker.Events.UserEmailChanged do
  @moduledoc false

  @derive Jason.Encoder
  defstruct [:user_id, :email]
end
