defmodule ExpenseTracker.Events.UserEnabled do
  @moduledoc false

  @derive Jason.Encoder
  defstruct [:user_id]
end
