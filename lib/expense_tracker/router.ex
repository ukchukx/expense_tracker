defmodule ExpenseTracker.Router do
  alias ExpenseTracker.Middleware.{Telemetry, Uniqueness, Validate}
  alias ExpenseTracker.Aggregates.{Budget, ExpenseItem, User}

  alias ExpenseTracker.Commands.{
    CreateUser,
    DisableUser,
    EnableUser,
    UpdateUser,
    CreateBudget,
    DeleteBudget,
    CreateExpenseItem,
    DeleteExpenseItem
  }

  use Commanded.Commands.Router

  middleware(Telemetry)
  middleware(Validate)
  middleware(Uniqueness)

  identify(User, by: :user_id, prefix: "user-")
  identify(Budget, by: :budget_id, prefix: "budget-")
  identify(ExpenseItem, by: :expense_item_id, prefix: "expense-item-")

  dispatch(
    [
      CreateUser,
      DisableUser,
      EnableUser,
      UpdateUser
    ],
    to: User,
    lifespan: User,
    timeout: Application.get_env(:expense_tracker, :router)[:timeout]
  )

  dispatch(
    [
      CreateBudget,
      DeleteBudget
    ],
    to: Budget,
    lifespan: Budget,
    timeout: Application.get_env(:expense_tracker, :router)[:timeout]
  )

  dispatch(
    [
      CreateExpenseItem,
      DeleteExpenseItem
    ],
    to: ExpenseItem,
    lifespan: ExpenseItem,
    timeout: Application.get_env(:expense_tracker, :router)[:timeout]
  )
end
