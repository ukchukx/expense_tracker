defmodule ExpenseTracker.Queries.Budgets do
  @moduledoc false

  alias ExpenseTracker.Projections.Budget

  import Ecto.Query

  def for_user(user_id), do: from(b in Budget, where: b.user_id == ^user_id)

  def latest_first(query), do: order_by(query, [b], desc: b.start_date)

  def for_user(query, id), do: from(q in query, where: q.user_id == ^id)

  def by_name_and_user(name, user_id),
    do: from(b in Budget, where: b.user_id == ^user_id and b.name == ^name)
end
