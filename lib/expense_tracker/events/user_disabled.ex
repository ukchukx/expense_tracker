defmodule ExpenseTracker.Events.UserDisabled do
  @moduledoc false

  @derive Jason.Encoder
  defstruct [:user_id]
end
