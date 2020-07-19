defmodule ExpenseTracker.Queries.Users do
  alias ExpenseTracker.Projections.User

  import Ecto.Query

  def active_users, do: from u in User, where: u.active

  def by_email(email), do: from u in User, where: u.email == ^email

  def for_user(query, id), do: from q in query, where: q.user_id == ^id
end
