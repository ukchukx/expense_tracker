defmodule ExpenseTracker.Projectors.User do
  use Commanded.Projections.Ecto,
    name: "Projector.User",
    application: ExpenseTracker.CommandedApp,
    consistency: :strong

  alias ExpenseTracker.Events.{
    UserEmailChanged,
    UserDisabled,
    UserEnabled,
    UserPasswordChanged,
    UserCreated
  }
  alias ExpenseTracker.Projections.User
  alias ExpenseTracker.Queries.ById
  alias ExpenseTracker.Support.Utils

  project %UserCreated{user_id: id} = event, fn multi ->
    changes =
      event
      |> Utils.to_map
      |> Map.drop([:user_id])
      |> Map.put(:id, id)

    Ecto.Multi.insert(multi, :user, struct(User, changes))
  end

  project %UserDisabled{user_id: id}, fn multi ->
    update_user(multi, id, active: false)
  end

  project %UserEnabled{user_id: id}, fn multi ->
    update_user(multi, id, active: true)
  end

  project %UserEmailChanged{user_id: id, email: email}, fn multi ->
    update_user(multi, id, email: email)
  end

  project %UserPasswordChanged{user_id: id, password: hashed_password}, fn multi ->
    update_user(multi, id, password: hashed_password)
  end

  defp update_user(multi, id, changes) do
    Ecto.Multi.update_all(multi, :user, ById.one(User, id), set: changes)
  end
end
