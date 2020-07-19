defmodule ExpenseTracker.Budgets do
  alias ExpenseTracker.Commands.{CreateBudget, DeleteBudget}
  alias ExpenseTracker.Queries.{ById, Budgets}
  alias ExpenseTracker.{Commands, Queries}
  alias ExpenseTracker.Projections.Budget
  alias ExpenseTracker.Support.Utils


  def build_create_budget_command(%{start_date: d} = attrs, %{user: %{id: id}} = _context) do
    attrs =
      attrs
      |> Map.put(:user_id, id)
      |> Map.put(:name, Utils.budget_name(d))
      |> Map.put(:budget_id, Ecto.UUID.generate())

    struct(CreateBudget, attrs)
  end

  def create_budget(%{} = attrs, %{user: %{}} = context) do
    attrs
    |> build_create_budget_command(context)
    |> Commands.dispatch
    |> case do
      {:ok, %{id: id}} -> budget_by_id(id)
      response -> response
    end
  end

  def delete_budget(%{id: id} = _budget) do
    with {:ok, _} <- budget_by_id(id),
         {:ok, _state}	<- DeleteBudget |> struct(%{budget_id: id}) |> Commands.dispatch do
      :ok
    else
      res -> res
    end
  end

  def budget_by_id(id) when is_binary(id), do: Budget |> ById.one(id) |> Queries.fetch_one

  def budgets_for_user(user_id), do: user_id |> Budgets.for_user |> Queries.fetch_all

end
