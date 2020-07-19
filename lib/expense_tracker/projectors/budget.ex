defmodule ExpenseTracker.Projectors.Budget do
  use Commanded.Projections.Ecto,
    name: "Projector.Budget",
    application: ExpenseTracker.CommandedApp,
    consistency: :strong

  alias ExpenseTracker.Events.{BudgetCreated, BudgetDeleted}
  alias ExpenseTracker.Projections.Budget
  alias ExpenseTracker.Queries.ById
  alias ExpenseTracker.Support.Utils

  project %BudgetCreated{budget_id: id, start_date: s, end_date: e} = event, fn multi ->
    changes =
      event
      |> Utils.to_map
      |> Map.drop([:budget_id])
      |> Map.put(:id, id)
      |> Map.put(:start_date, Date.from_iso8601!(s))
      |> Map.put(:end_date, Date.from_iso8601!(e))

    Ecto.Multi.insert(multi, :budget, struct(Budget, changes))
  end

  project %BudgetDeleted{budget_id: id}, fn multi ->
    Ecto.Multi.delete_all(multi, :budget, ById.one(Budget, id))
  end
end
