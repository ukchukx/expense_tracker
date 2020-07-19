defmodule ExpenseTracker.Projectors.ExpenseItem do
  use Commanded.Projections.Ecto,
    name: "Projector.ExpenseItem",
    application: ExpenseTracker.CommandedApp,
    consistency: :strong

  alias ExpenseTracker.Events.{ExpenseItemCreated, ExpenseItemDeleted}
  alias ExpenseTracker.Projections.ExpenseItem
  alias ExpenseTracker.Queries.ById
  alias ExpenseTracker.Support.Utils

  project %ExpenseItemCreated{expense_item_id: id, budget_id: budget_id} = event, fn multi ->
    {:ok, %{user_id: user_id}} = ExpenseTracker.Budgets.budget_by_id(budget_id)
    changes =
      event
      |> Utils.to_map
      |> Map.drop([:expense_item_id])
      |> Map.put(:id, id)
      |> Map.put(:user_id, user_id)

    Ecto.Multi.insert(multi, :expense_item, struct(ExpenseItem, changes))
  end

  project %ExpenseItemDeleted{expense_item_id: id}, fn multi ->
    Ecto.Multi.delete_all(multi, :expense_item, ById.one(ExpenseItem, id))
  end
end
