defmodule ExpenseTracker.Router do
  alias ExpenseTracker.Middleware.{Telemetry, Uniqueness, Validate}
  alias ExpenseTracker.Aggregates.User
  alias ExpenseTracker.Commands.{
    CreateUser,
    DisableUser,
    EnableUser,
    UpdateUser
  }

  use Commanded.Commands.Router

  middleware Telemetry
  middleware Validate
  middleware Uniqueness

  identify User, by: :user_id,   prefix: "user-"

  dispatch [
    CreateUser,
    DisableUser,
    EnableUser,
    UpdateUser
  ], to: User, lifespan: User, timeout: Application.get_env(:expense_tracker, :router)[:timeout]
end
