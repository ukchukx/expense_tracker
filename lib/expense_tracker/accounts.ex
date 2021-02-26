defmodule ExpenseTracker.Accounts do
  alias ExpenseTracker.Commands.{CreateUser, DisableUser, EnableUser, UpdateUser}
  alias ExpenseTracker.Queries.{ById, Users}
  alias ExpenseTracker.{Commands, Queries}
  alias ExpenseTracker.Projections.User

  def build_create_user_command(%{} = attrs) do
    attrs =
      attrs
      |> Map.delete(:active)
      |> Map.put(:user_id, Ecto.UUID.generate())

    CreateUser
    |> struct(attrs)
    |> CreateUser.downcase_email()
    |> CreateUser.hash_password()
  end

  def build_update_user_command(%{} = user, %{} = attrs) do
    UpdateUser
    |> struct(Map.delete(attrs, :active))
    |> UpdateUser.assign_user(user)
    |> UpdateUser.downcase_email()
    |> UpdateUser.hash_password()
  end

  def create_user(%{} = attrs) do
    attrs
    |> build_create_user_command
    |> Commands.dispatch()
    |> case do
      {:ok, %{id: id}} -> user_by_id(id)
      response -> response
    end
  end

  def update_user(%{id: id} = _user, attrs = %{}) do
    with {:ok, %{} = user} <- user_by_id(id),
         {:ok, %{id: id}} <- user |> build_update_user_command(attrs) |> Commands.dispatch() do
      user_by_id(id)
    else
      reply -> reply
    end
  end

  def enable_user(%{id: id} = user) do
    with {:ok, %{active: false}} <- user_by_id(id),
         {:ok, _state} <- EnableUser |> struct(%{user_id: id}) |> Commands.dispatch() do
      {:ok, %{user | active: true}}
    else
      {:ok, _} -> {:error, :already_enabled}
      res -> res
    end
  end

  def disable_user(%{id: id} = user) do
    with {:ok, %{active: true}} <- user_by_id(id),
         {:ok, _state} <- DisableUser |> struct(%{user_id: id}) |> Commands.dispatch() do
      {:ok, %{user | active: false}}
    else
      {:ok, _} -> {:error, :already_disabled}
      res -> res
    end
  end

  def user_by_id(id), do: User |> ById.one(id) |> Queries.fetch_one()

  def user_by_email(email) do
    email
    |> String.downcase()
    |> Users.by_email()
    |> Queries.fetch_one()
  end
end
