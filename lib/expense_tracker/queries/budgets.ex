defmodule ExpenseTracker.Queries.Budgets do
  alias ExpenseTracker.Projections.Budget

  import Ecto.Query

  def for_user(user_id), do: from b in Budget, where: b.user_id == ^user_id

  def for_user(query, id), do: from q in query, where: q.user_id == ^id
end
