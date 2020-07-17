defmodule ExpenseTracker.CommandedApp do
  use Commanded.Application, otp_app: :expense_tracker

  router ExpenseTracker.Router
end
