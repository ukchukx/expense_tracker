defmodule ExpenseTracker.CommandedApp do
  @moduledoc false

  use Commanded.Application, otp_app: :expense_tracker

  router(ExpenseTracker.Router)
end
