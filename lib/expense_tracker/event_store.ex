defmodule ExpenseTracker.EventStore do
  @moduledoc false

  use EventStore, otp_app: :expense_tracker
end
