defmodule ExpenseTracker.ExpenseItemTest do
  alias ExpenseTracker.{Budgets, DataCase}
  alias ExpenseTracker.Projections.ExpenseItem

  use DataCase

  @moduletag models: :expense_item
  @moduletag :expense_item

  describe "an expense item" do
    test "can be created" do
      assert {:ok, %ExpenseItem{id: expense_item_id}} = fixture(:expense_item)
      assert {:ok, _} = Budgets.expense_item_by_id(expense_item_id)
    end

    test "can be listed for a budget" do
      assert {:ok, %ExpenseItem{budget_id: budget_id}} = fixture(:expense_item)
      assert [%{}] = Budgets.expense_items_for_budget(budget_id)
    end

    test "can be listed for a user" do
      assert {:ok, %ExpenseItem{user_id: user_id}} = fixture(:expense_item)
      assert [%{}] = Budgets.expense_items_for_user(user_id)
    end

    test "can be listed for a line item" do
      assert {:ok, %ExpenseItem{user_id: user_id, line_item_id: item_id}} = fixture(:expense_item)
      assert [%{}] = Budgets.expense_items_for_line_item(item_id)
    end

    test "can be deleted" do
      assert {:ok, %ExpenseItem{id: expense_item_id} = expense_item} = fixture(:expense_item)
      assert :ok = Budgets.delete_expense_item(expense_item)
      assert {:error, :not_found} = Budgets.expense_item_by_id(expense_item_id)
    end
  end
end
