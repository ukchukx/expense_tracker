defmodule ExpenseTracker.BudgetTest do
  alias ExpenseTracker.{Budgets, DataCase}
  alias ExpenseTracker.Projections.Budget

  use DataCase

  @moduletag models: :budget
  @moduletag :budget

  describe "a budget" do
    test "can be created" do
      assert {:ok, %Budget{id: budget_id}} = fixture(:budget)
      assert {:ok, _} = Budgets.budget_by_id(budget_id)
    end

    test "can be deleted" do
      assert {:ok, %Budget{id: budget_id} = budget} = fixture(:budget)
      assert :ok = Budgets.delete_budget(budget)
      assert {:error, :not_found} = Budgets.budget_by_id(budget_id)
    end
  end
end
