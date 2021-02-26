defmodule ExpenseTracker.Queries.ById do
  import Ecto.Query

  def one(projection, id), do: from(p in projection, where: p.id == ^id)

  def many(projection, ids) when is_list(ids), do: from(p in projection, where: p.id in ^ids)
end
