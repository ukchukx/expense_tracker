defmodule ExpenseTracker.BudgetTest do
  alias ExpenseTracker.{Budgets, DataCase}
  alias ExpenseTracker.Projections.Budget
  alias ExpenseTracker.Validators.Uuid

  use DataCase

  @moduletag models: :budget
  @moduletag :budget

  describe "a budget" do
    test "can be created" do
      assert {:ok, %Budget{id: budget_id}} = fixture(:budget)
      assert {:ok, _} = Budgets.budget_by_id(budget_id)
    end

    test "contains line items that each have ids" do
      assert {:ok, %Budget{line_items: line_items}} = fixture(:budget)
      assert Enum.all?(line_items, &(Uuid.validate(&1["id"]) == :ok))
    end

    test "can be listed for a user" do
      assert {:ok, %Budget{user_id: user_id}} = fixture(:budget)
      assert [%{}] = Budgets.budgets_for_user(user_id)
    end

    test "can be deleted" do
      assert {:ok, %Budget{id: budget_id} = budget} = fixture(:budget)
      assert :ok = Budgets.delete_budget(budget)
      assert {:error, :not_found} = Budgets.budget_by_id(budget_id)
    end

    test "can only be created once with the same name" do
      assert {:ok, %Budget{id: budget_id, user_id: user_id} = a} = fixture(:budget)
      context = %{user: %{id: user_id}}
      params = ExpenseTracker.Factory.build_budget_params()
      assert {:ok, %Budget{id: existing_budget_id} = b} = Budgets.create_budget(params, context)
      assert budget_id == existing_budget_id
    end

    test "adds an unbudgeted item on creation" do
      assert {:ok, %Budget{line_items: items}} = fixture(:budget)
      assert Enum.any?(items, &(&1["description"] == "Unbudgeted"))
    end
  end
end
