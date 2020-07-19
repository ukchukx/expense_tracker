defmodule ExpenseTracker.Queries.ExpenseItems do
  alias ExpenseTracker.Projections.ExpenseItem

  import Ecto.Query

  def for_budget(budget_id), do: from b in ExpenseItem, where: b.budget_id == ^budget_id

  def for_budget(query, id), do: from q in query, where: q.budget_id == ^id

  def for_user(user_id), do: from b in ExpenseItem, where: b.user_id == ^user_id

  def for_user(query, id), do: from q in query, where: q.user_id == ^id
end
