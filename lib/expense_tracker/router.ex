defmodule ExpenseTracker.Router do
  alias ExpenseTracker.Middleware.{Telemetry, Uniqueness, Validate}
  alias ExpenseTracker.Aggregates.{Budget, User}
  alias ExpenseTracker.Commands.{
    CreateUser,
    DisableUser,
    EnableUser,
    UpdateUser,
    CreateBudget,
    DeleteBudget
  }

  use Commanded.Commands.Router

  middleware Telemetry
  middleware Validate
  middleware Uniqueness

  identify User, by: :user_id,   prefix: "user-"
  identify Budget, by: :budget_id,   prefix: "budget-"

  dispatch [
    CreateUser,
    DisableUser,
    EnableUser,
    UpdateUser
  ], to: User, lifespan: User, timeout: Application.get_env(:expense_tracker, :router)[:timeout]

  dispatch [
    CreateBudget,
    DeleteBudget
  ], to: Budget, lifespan: Budget, timeout: Application.get_env(:expense_tracker, :router)[:timeout]
end
